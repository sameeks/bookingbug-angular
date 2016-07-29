'use strict';


###**
* @ngdoc directive
* @name BB.Directives:bbItemDetails
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of item details for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} item An array of all item details
* @property {array} product The product
* @property {array} booking The booking
* @property {array} upload_progress The item upload progress
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
###


angular.module('BB.Directives').directive 'bbItemDetails', ($q, $templateCache, $compile) ->
  restrict: 'AE'
  replace: true
  scope : true
  transclude: true
  controller : 'ItemDetails'
  link: (scope, element, attrs, controller, transclude) ->
    if attrs.bbItemDetails
      item = scope.$eval(attrs.bbItemDetails)
      scope.item_from_param = item
      delete scope.item_details if scope.item_details
      scope.loadItem(item) if item

    transclude scope, (clone) =>
      # if there's content compile that or grab the week_calendar template
      has_content = clone.length > 1 || (clone.length == 1 && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)))
      if has_content
        element.html(clone).show()
      else
        $q.when($templateCache.get('_item_details.html')).then (template) ->
          element.html(template).show()
          $compile(element.contents())(scope)



angular.module('BB.Controllers').controller 'ItemDetails', ($scope, $attrs, $rootScope, ItemDetailsService, PurchaseBookingService, AlertService, BBModel, FormDataStoreService, ValidatorService, QuestionService, $uibModal, $document, $location, $translate, SettingsService, PurchaseService) ->

  $scope.controller = "public.controllers.ItemDetails"

  $scope.suppress_basket_update = $attrs.bbSuppressBasketUpdate?
  $scope.item_details_id = $scope.$eval $attrs.bbSuppressBasketUpdate

  # if instructed to suppress basket updates (i.e. when the directive is invoked multiple times
  # on the same page), create a form store for each instance of the directive
  if $scope.suppress_basket_update
    FormDataStoreService.init ('ItemDetails'+$scope.item_details_id), $scope, ['item_details']
  else
    FormDataStoreService.init 'ItemDetails', $scope, ['item_details']

  # populate object with values stored in the question store. addAnswersByName()
  # is good for populating a single object. for dynamic question/answers see
  # addDynamicAnswersByName()
  QuestionService.addAnswersByName($scope.client, [
    'first_name'
    'last_name'
    'email'
    'mobile'
  ])

  $scope.validator = ValidatorService
  confirming = false


  $rootScope.connection_started.then () ->
    $scope.loadItem($scope.bb.current_item) if !confirming
  , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name loadItem
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Load item in according of item parameter
  *
  * @param {array} item The item loaded
  ###
  $scope.loadItem = (item) ->

    $scope.notLoaded $scope

    confirming = true
    $scope.item = item
    $scope.item.private_note = $scope.bb.private_note if $scope.bb.private_note
    $scope.product = item.product

    if $scope.item.item_details
      setItemDetails $scope.item.item_details
      # this will add any values in the querystring
      QuestionService.addDynamicAnswersByName($scope.item_details.questions)
      QuestionService.addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers) if $scope.bb.item_defaults.answers
      $scope.recalc_price()
      $scope.setLoaded $scope
      $scope.$emit "item_details:loaded", $scope.item_details

    else

      params = {company: $scope.bb.company, cItem: $scope.item}
      ItemDetailsService.query(params).then (details) ->
        if details
          setItemDetails details
          $scope.item.item_details = $scope.item_details
          QuestionService.addDynamicAnswersByName($scope.item_details.questions)
          QuestionService.addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers) if $scope.bb.item_defaults.answers
          $scope.recalc_price()
          $scope.$emit "item_details:loaded", $scope.item_details
        $scope.setLoaded $scope

      , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name setItemDetails
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Set item details in according of details parameter
  *
  * @param {array} details The details parameter
  ###
  # compare the questions stored in the data store to the new questions and if
  # any of them match then copy the answer value. we're doing it like this as
  # the amount of questions can change based on selections made earlier in the
  # journey, so we can't just store the questions.
  setItemDetails = (details) ->
    if $scope.item && $scope.item.defaults
      _.each details.questions, (item) ->
        n = "q_" + item.name
        if $scope.item.defaults[n]
          item.answer = $scope.item.defaults[n]

    if $scope.hasOwnProperty 'item_details'
      oldQuestions = $scope.item_details.questions

      _.each details.questions, (item) ->
        search = _.findWhere(oldQuestions, { name: item.name })
        if search
          item.answer = search.answer
    $scope.item_details = details

  # TODO document listener
  $scope.$on 'currentItemUpdate', (event) ->
    if $scope.item_from_param
      $scope.loadItem($scope.item_from_param)
    else
      $scope.loadItem($scope.bb.current_item)

  ###**
  * @ngdoc method
  * @name recalc_price
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Recalculate item price in function of quantity
  ###
  $scope.recalc_price = ->
    qprice = $scope.item_details.questionPrice($scope.item.getQty())
    bprice = $scope.item.base_price
    bprice = $scope.item.price unless bprice

    $scope.item.setPrice(qprice + bprice)



  ###**
  * @ngdoc method
  * @name confirm
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Confirm the question
  *
  * @param {object} form The form where question are introduced
  * @param {string=} route A specific route to load
  ###
  $scope.confirm = (form, route) ->
    return if !ValidatorService.validateForm(form)
    # we need to validate the question information has been correctly entered here
    if $scope.bb.moving_booking
      return $scope.confirm_move(form, route)

    $scope.item.setAskedQuestions()

    return true if $scope.$parent.$has_page_control


    if $scope.item.ready
      $scope.notLoaded $scope
      $scope.addItemToBasket().then () ->
        $scope.setLoaded $scope
        $scope.decideNextPage(route)
      , (err) ->
        $scope.setLoaded $scope
    else
      $scope.decideNextPage(route)

  ###**
  * @ngdoc method
  * @name setReady
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
  ###
  $scope.setReady = () =>
    $scope.item.setAskedQuestions()
    if $scope.item.ready and !$scope.suppress_basket_update
      return $scope.addItemToBasket()
    else
      return true

  ###**
  * @ngdoc method
  * @name confirm_move
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Confirm move question information has been correctly entered here
  *
  * @param {string=} route A specific route to load
  ###
  $scope.confirm_move = (route) ->

    confirming = true
    $scope.item ||= $scope.bb.current_item
    $scope.item.moved_booking = false
    # we need to validate the question information has been correctly entered here
    $scope.item.setAskedQuestions()
    if $scope.item.ready
      $scope.notLoaded $scope
      if $scope.bb.moving_purchase
        params =
          purchase: $scope.bb.moving_purchase
          bookings: $scope.bb.basket.items
        PurchaseService.update(params).then (purchase) ->
          $scope.bb.purchase = purchase
          $scope.bb.purchase.getBookingsPromise().then (bookings)->
            $scope.purchase = purchase
            $scope.setLoaded $scope
            $scope.item.move_done = true
            $scope.item.moved_booking = true
            $rootScope.$broadcast "booking:moved"
            $scope.decideNextPage(route)
            $scope.showMoveMessage(bookings[0].datetime)


        , (err) ->
           $scope.setLoaded $scope
           AlertService.add("danger", { msg: "Failed to move booking. Please try again." })
      else
        PurchaseBookingService.update($scope.item).then (booking) ->
          b = new BBModel.Purchase.Booking(booking)

          if $scope.bb.purchase
            for oldb, _i in $scope.bb.purchase.bookings
              $scope.bb.purchase.bookings[_i] = b if oldb.id == b.id

          $scope.setLoaded $scope
          $scope.bb.moved_booking = booking
          $scope.item.move_done = true
          $rootScope.$broadcast "booking:moved"
          $scope.decideNextPage(route)
          $scope.showMoveMessage(b.datetime)
         , (err) =>
          $scope.setLoaded $scope
          AlertService.add("danger", { msg: "Failed to move booking. Please try again." })
    else
      $scope.decideNextPage(route)

  $scope.showMoveMessage = (datetime) ->
    # TODO remove whem translate enabled by default
    if SettingsService.isInternationalizatonEnabled()
      $translate('MOVE_BOOKINGS_MSG', { datetime:datetime.format('LLLL') }).then (translated_text) ->
        AlertService.add("info", { msg: translated_text })
    else
      AlertService.add("info", { msg: "Your booking has been moved to #{datetime.format('LLLL')}" })


  ###**
  * @ngdoc method
  * @name openTermsAndConditions
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Display terms and conditions view
  ###
  $scope.openTermsAndConditions = () ->
    modalInstance = $uibModal.open(
      appendTo: angular.element($document[0].getElementById('bb'))
      templateUrl: $scope.getPartial "terms_and_conditions"
      scope: $scope
    )

  ###**
  * @ngdoc method
  * @name getQuestion
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Get question by id
  *
  * @param {integer} id The id of the question
  ###
  $scope.getQuestion = (id) ->
    for question in $scope.item_details.questions
      return question if question.id == id

    return null

  ###**
  * @ngdoc method
  * @name updateItem
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Update item
  ###
  $scope.updateItem = () ->
    $scope.item.setAskedQuestions()
    if $scope.item.ready
      $scope.notLoaded $scope

      PurchaseBookingService.update($scope.item).then (booking) ->

        b = new BBModel.Purchase.Booking(booking)
        if $scope.bookings
          for oldb, _i in $scope.bookings
            if oldb.id == b.id
              $scope.bookings[_i] = b

        $scope.purchase.bookings = $scope.bookings
        $scope.item_details_updated = true
        $scope.setLoaded $scope

       , (err) =>
        $scope.setLoaded $scope

  ###**
  * @ngdoc method
  * @name editItem
  * @methodOf BB.Directives:bbItemDetails
  * @description
  * Edit item
  ###
  $scope.editItem = () ->
    $scope.item_details_updated = false
