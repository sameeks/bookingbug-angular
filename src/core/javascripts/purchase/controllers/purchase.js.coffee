###**
* @ngdoc directive
* @name BB.Directives:bbPurchase
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of purchase in scope company.
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbPurchase Hash options
* @property {boolean} is_waitlist Purchase is on wait list or not
* @property {boolean} make_payment Purchase payment made or not
* @property {object} alert Alert service - see {@link BB.Services:Alert Alert Service}
####

angular.module('BB.Directives').directive 'bbPurchase', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Purchase'
  link : (scope, element, attrs) ->
    scope.init(scope.$eval( attrs.bbPurchase ))
    return

angular.module('BB.Controllers').controller 'Purchase', ($scope,  $rootScope, PurchaseService, ClientService, $modal, $location, $timeout, BBWidget, BBModel, $q, QueryStringService, SSOService, AlertService, LoginService, $window, $upload, ServiceService, $sessionStorage, LoadingService, SettingsService, $translate) ->

  $scope.controller = "Purchase"
  $scope.is_waitlist = false
  $scope.make_payment = false
  loader = LoadingService.$loader($scope)

  ###**
  * @ngdoc method
  * @name setPurchaseCompany
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Set purchase company according to company parameter.
  *
  * @param {object} company Company
  ###
  setPurchaseCompany = (company) ->
    $scope.bb.company_id = company.id
    $scope.bb.company = new BBModel.Company(company)
    $scope.company = $scope.bb.company
    $scope.bb.item_defaults.company = $scope.bb.company
    if company.settings
      $scope.bb.item_defaults.merge_resources = true if company.settings.merge_resources
      $scope.bb.item_defaults.merge_people    = true if company.settings.merge_people

  ###**
  * @ngdoc method
  * @name failMsg
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Display a fail message.
  *
  * @param {object} failMsg Fail message
  ###
  failMsg = () ->
    if $scope.fail_msg
      AlertService.danger({msg:$scope.fail_msg})
    else
      if SettingsService.isInternationalizatonEnabled()
        $translate('ERROR.GENERIC', {}).then (translated_text) ->
          AlertService.add("danger", { msg: translated_text })
      else
        AlertService.raise('GENERIC')

  ###**
  * @ngdoc method
  * @name init
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Initializate the purchase according to options parameter.
  *
  * @param {array} options Options of purchase
  ###
  $scope.init = (options) ->
    options = {} if !options

    loader.notLoaded()
    $scope.move_route = options.move_route if options.move_route
    $scope.move_all = options.move_all if options.move_all
    $scope.fail_msg = options.fail_msg if options.fail_msg

    # is there a purchase total already in scope?
    if $scope.bb.total
      $scope.load($scope.bb.total.long_id)
    else if $scope.bb.purchase
      $scope.purchase = $scope.bb.purchase
      $scope.bookings = $scope.bb.purchase.bookings
      $scope.messages = $scope.purchase.confirm_messages if $scope.purchase.confirm_messages
      loader.setLoaded()
    else
      if options.member_sso
        SSOService.memberLogin(options).then (login) ->
          $scope.load()
        , (err) ->
          loader.setLoaded()
          failMsg()
      else
        $scope.load()

  ###**
  * @ngdoc method
  * @name load
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Load purchase according to id parameter.
  *
  * @param {integer} id Purchase id
  ###
  $scope.load = (id) ->
    loader.notLoaded()

    id = getPurchaseID()

    unless $scope.loaded || !id
      $rootScope.widget_started.then () =>
        $scope.waiting_for_conn_started.then () =>
          company_id = getCompanyID()
          if company_id
            BBModel.Company.$query(company_id, {}).then (company) ->
              setPurchaseCompany(company)
          params = {purchase_id: id, url_root: $scope.bb.api_url}
          auth_token = $sessionStorage.getItem('auth_token')
          params.auth_token = auth_token if auth_token
          PurchaseService.query(params).then (purchase) ->
            unless $scope.bb.company?
              purchase.$get('company').then (company) =>
                setPurchaseCompany(company)
            $scope.purchase = purchase
            $scope.bb.purchase = purchase
            $scope.price = !($scope.purchase.price == 0)

            $scope.purchase.$getBookings().then (bookings) ->
              $scope.bookings = bookings

              if bookings[0]
                bookings[0].$getCompany().then (company) ->
                  $scope.purchase.bookings[0].company = company
                  company.$getAddress().then (address) ->
                    $scope.purchase.bookings[0].company.address = address

              loader.setLoaded()
              checkIfMoveBooking(bookings)
              checkIfWaitlistBookings(bookings)

              for booking in $scope.bookings
                booking.$getAnswers().then (answers) ->
                  booking.answers = answers
            , (err) ->
              loader.setLoaded()
              failMsg()

            if purchase.$has('client')
              purchase.$get('client').then (client) =>
                $scope.setClient(new BBModel.Client(client))
            $scope.purchase.getConfirmMessages().then (messages) ->
              $scope.purchase.confirm_messages = messages
              $scope.messages = messages
          , (err) ->
            loader.setLoaded()
            if err && err.status == 401
              if LoginService.isLoggedIn()
                # TODO don't show fail message, display message that says you're logged in as someone else and offer switch user function (logout and show login)
                failMsg()
              else
                loginRequired()
            else
              failMsg()
        , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

    $scope.loaded = true

  ###**
  * @ngdoc method
  * @name checkIfMoveBooking
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Checks move bookings according to bookings parameter.
  *
  * @param {array} bookings Bookings array
  ###
  checkIfMoveBooking = (bookings) ->
    matches = /^.*(?:\?|&)move_booking=(.*?)(?:&|$)/.exec($location.absUrl())
    id = parseInt(matches[1]) if matches
    if id
      move_booking = (b for b in bookings when b.id == id)
      $scope.move(move_booking[0]) if move_booking.length > 0 && $scope.isMovable(bookings[0])

  ###**
  * @ngdoc method
  * @name checkIfWaitlistBookings
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Checks wait list bookings according to bookings parameter.
  *
  * @param {array} bookings Bookings array
  ###
  checkIfWaitlistBookings = (bookings) ->
    $scope.waitlist_bookings = (booking for booking in bookings when (booking.on_waitlist && booking.settings.sent_waitlist == 1))

  ###**
  * @ngdoc method
  * @name loginRequired
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Login required.
  ###
  loginRequired = () =>
    if !$scope.bb.login_required
      window.location = window.location.href + "&login=true"

  ###**
  * @ngdoc method
  * @name getCompanyID
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Get the company id.
  ###
  getCompanyID = () ->
    matches = /^.*(?:\?|&)company_id=(.*?)(?:&|$)/.exec($location.absUrl())
    company_id = matches[1] if matches
    company_id

  ###**
  * @ngdoc method
  * @name getPurchaseID
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Get the purchase id.
  ###
  getPurchaseID = () ->
    matches = /^.*(?:\?|&)id=(.*?)(?:&|$)/.exec($location.absUrl())
    unless matches
      matches = /^.*print_purchase\/(.*?)(?:\?|$)/.exec($location.absUrl())
    unless matches
      matches = /^.*print_purchase_jl\/(.*?)(?:\?|$)/.exec($location.absUrl())

    if matches
      id = matches[1]
    else
      id = QueryStringService('ref') if QueryStringService('ref')
    id = QueryStringService('booking_id')  if QueryStringService('booking_id')
    id


  $scope.move = (booking, route, options = {}) ->

    route ||= $scope.move_route
    if $scope.move_all
      return $scope.moveAll(route, options)

    loader.notLoaded()
    $scope.initWidget({company_id: booking.company_id, no_route: true})
    $timeout () =>
      $rootScope.connection_started.then () =>
        proms = []
        $scope.bb.moving_booking = booking
        $scope.quickEmptybasket()
        new_item = new BBModel.BasketItem(booking, $scope.bb)
        new_item.setSrcBooking(booking, $scope.bb)
        new_item.ready = false
        Array::push.apply proms, new_item.promises
        $scope.bb.basket.addItem(new_item)
        $scope.setBasketItem(new_item)

        $q.all(proms).then () ->
          loader.setLoaded()
          $rootScope.$broadcast "booking:move"
          $scope.decideNextPage(route)
        , (err) ->
          loader.setLoaded()
          failMsg()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name moveAll
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Potentially move all items in booking - move the whole lot to a basket.
  *
  * @param {string} route Route
  * @param {object} options Options
  ###
  # potentially move all items in booking - move the whole lot to a basket
  $scope.moveAll = (route, options = {}) ->
    route ||= $scope.move_route
    loader.notLoaded()
    $scope.initWidget({company_id: $scope.bookings[0].company_id, no_route: true})
    $timeout () =>
      $rootScope.connection_started.then () =>
        proms = []
        if $scope.bookings.length == 1
          $scope.bb.moving_booking = $scope.bookings[0]
        else
          $scope.bb.moving_booking = $scope.purchase

        if _.every(_.map($scope.bookings, (b) -> b.event_id),
                   (event_id) -> event_id == $scope.bookings[0].event_id)
          $scope.bb.moving_purchase = $scope.purchase

        $scope.quickEmptybasket()
        for booking in $scope.bookings
          new_item = new BBModel.BasketItem(booking, $scope.bb)
          new_item.setSrcBooking(booking)
          new_item.ready = false
          new_item.move_done = false
          Array::push.apply proms, new_item.promises
          $scope.bb.basket.addItem(new_item)
        $scope.bb.sortStackedItems()

        $scope.setBasketItem($scope.bb.basket.items[0])
        $q.all(proms).then () ->
          loader.setLoaded()
          $scope.decideNextPage(route)
        , (err) ->
          loader.setLoaded()
          failMsg()
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name bookWaitlistItem
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Book wait list items.
  *
  * @param {array} booking Booking
  ###
  $scope.bookWaitlistItem = (booking) ->
    loader.notLoaded()
    params = { purchase: $scope.purchase, booking: booking }
    PurchaseService.bookWaitlistItem(params).then (purchase) ->
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.bb.purchase = purchase
      $scope.purchase.$getBookings().then (bookings) ->
        $scope.bookings = bookings
        $scope.waitlist_bookings = (booking for booking in $scope.bookings when (booking.on_waitlist && booking.settings.sent_waitlist == 1))
        if $scope.purchase.$has('new_payment') && $scope.purchase.due_now > 0
          $scope.make_payment = true
        loader.setLoaded()
      , (err) ->
        loader.setLoaded()
        failMsg()
    , (err) =>
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


  ###**
  * @ngdoc method
  * @name delete
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Delete a single booking.
  *
  * @param {array} booking Booking
  ###
  # delete a single booking
  $scope.delete = (booking) ->
    modalInstance = $modal.open
      templateUrl: $scope.getPartial "_cancel_modal"
      controller: ModalDelete
      resolve:
        booking: ->
          booking
    modalInstance.result.then (booking) ->
      booking.$del('self').then (service) =>
        $scope.bookings = _.without($scope.bookings, booking)
        $rootScope.$broadcast "booking:cancelled"

  ###**
  * @ngdoc method
  * @name deleteAll
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Delete all bookings.
  *
  ###
  # delete all bookings associated to the purchase
  $scope.deleteAll = () ->
    modalInstance = $modal.open
      templateUrl: $scope.getPartial "_cancel_modal"
      controller: ModalDeleteAll
      resolve:
        purchase: ->
          $scope.purchase
    modalInstance.result.then (purchase) ->
      PurchaseService.deleteAll(purchase).then (purchase) ->
        $scope.purchase = purchase
        $scope.bookings = []
        $rootScope.$broadcast "booking:cancelled"

  ###**
  * @ngdoc method
  * @name isMovable
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Verify if booking is movable.
  *
  * @param {array} booking Booking
  ###
  $scope.isMovable = (booking) ->
    if booking.min_cancellation_time
      return moment().isBefore(booking.min_cancellation_time)
    booking.datetime.isAfter(moment())

  ###**
  * @ngdoc method
  * @name onFileSelect
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Select a file.
  *
  * @param {array} booking Booking
  * @param {object} $file File
  * @param {object} existing Existing
  ###
  $scope.onFileSelect = (booking, $file, existing) ->
    $scope.upload_progress = 0
    file = $file
    att_id = null
    att_id = existing.id if existing
    method = "POST"
    method = "PUT" if att_id
    $scope.upload = $upload.upload({
      url: booking.$href('attachments'),
      method: method,
      # headers: {'header-key': 'header-value'},
      # withCredentials: true,
      data: {att_id: att_id},
      file: file, # or list of files: $files for html5 only
      # set the file formData name ('Content-Desposition'). Default is 'file'
      # fileFormDataName: myFile, //or a list of names for multiple files (html5).
      # customize how data is added to formData. See #40#issuecomment-28612000 for sample code
      # formDataAppender: function(formData, key, val){}
    }).progress (evt) ->
      if $scope.upload_progress < 100
        $scope.upload_progress = parseInt(99.0 * evt.loaded / evt.total)
    .success (data, status, headers, config) ->
      # file is uploaded successfully
      $scope.upload_progress = 100
      if data && data.attachments && booking
        booking.attachments = data.attachments
    #.error(...)
    #.then(success, error, progress);
    #.xhr(function(xhr){xhr.upload.addEventListener(...)})// access and attach any event listener to XMLHttpRequest.

    # alternative way of uploading, send the file binary with the file's content-type.
    #   Could be used to upload files to CouchDB, imgur, etc... html5 FileReader is needed.
    #   It could also be used to monitor the progress of a normal http post/put request with large data*/
    # $scope.upload = $upload.http({...})  see 88#issuecomment-31366487 for sample code.

  ###**
  * @ngdoc method
  * @name createBasketItem
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Create a basket item.
  *
  * @param {array} booking Booking
  ###
  $scope.createBasketItem = (booking) ->
    item = new BBModel.BasketItem(booking, $scope.bb)
    item.setSrcBooking(booking)
    return item

  ###**
  * @ngdoc method
  * @name checkAnswer
  * @methodOf BB.Directives:bbPurchase
  * @description
  * Check answer.
  *
  * @param {boolean} answer Answer
  * @param {string} answer Answer
  * @param {number} answer Answer
  ###
  $scope.checkAnswer = (answer) ->
    typeof answer.value == 'boolean' || typeof answer.value == 'string' || typeof answer.value == "number"


  $scope.changeAttendees = (route) ->
    $scope.moveAll(route)





# Simple modal controller for handling the 'delete' modal
ModalDelete = ($scope,  $rootScope, $modalInstance, booking) ->
  $scope.controller = "ModalDelete"
  $scope.booking = booking

  $scope.confirmDelete = () ->
    $modalInstance.close(booking)

  $scope.cancel = ->
    $modalInstance.dismiss "cancel"

# Simple modal controller for handling the 'delete all' modal
ModalDeleteAll = ($scope,  $rootScope, $modalInstance, purchase) ->
  $scope.controller = "ModalDeleteAll"
  $scope.purchase = purchase

  $scope.confirmDelete = () ->
    $modalInstance.close(purchase)

  $scope.cancel = ->
    $modalInstance.dismiss "cancel"
