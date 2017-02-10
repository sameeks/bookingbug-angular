'use strict'

angular.module('BB.Directives').directive 'bbPurchase', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Purchase'
  link : (scope, element, attrs) ->
    scope.init(scope.$eval( attrs.bbPurchase ))
    return

angular.module('BB.Controllers').controller 'Purchase', ($scope,  $rootScope,
  PurchaseService, $uibModal, $location, $timeout, BBModel, $q, QueryStringService,
  SSOService, AlertService, LoginService, $window, $sessionStorage, LoadingService,
  $translate, ReasonService, $document) ->

  $scope.is_waitlist = false
  $scope.make_payment = false
  loader = LoadingService.$loader($scope)

  $scope.$on "booking:moved", (event, bookings) ->
    $scope.purchase = bookings


  setPurchaseCompany = (company) ->

    $scope.bb.company_id = company.id
    $scope.bb.company = new BBModel.Company(company)
    $scope.company = $scope.bb.company
    $scope.bb.item_defaults.company = $scope.bb.company
    if company.settings
      $scope.bb.item_defaults.merge_resources = true if company.settings.merge_resources
      $scope.bb.item_defaults.merge_people    = true if company.settings.merge_people


  failMsg = () ->

    if $scope.fail_msg
      AlertService.danger({msg:$scope.fail_msg})
    else
      AlertService.add("danger", {msg: $translate.instant('CORE.ALERTS.GENERIC')})


  $scope.init = (options) ->

    options = {} if !options

    loader.notLoaded()
    $scope.move_route = options.move_route if options.move_route
    $scope.move_all = options.move_all if options.move_all
    $scope.fail_msg = options.fail_msg if options.fail_msg
    if $scope.purchase
      $scope.bb.purchase = $scope.purchase

    # is there a purchase total already in scope?
    if $scope.bb.total
      $scope.load($scope.bb.total.long_id)
    else if $scope.bb.purchase
      $scope.purchase = $scope.bb.purchase
      $scope.bookings = $scope.bb.purchase.bookings
      $scope.messages = $scope.purchase.confirm_messages if $scope.purchase.confirm_messages
      $scope.cancel_reasons = $scope.bb.cancel_reasons unless $scope.cancel_reasons
      $scope.move_reasons = $scope.bb.move_reasons unless $scope.move_reasons
      loader.setLoaded()
    else if options.member_sso
      SSOService.memberLogin(options).then (login) ->
        $scope.load()
      , (err) ->
        loader.setLoaded()
        failMsg()
    else
      $scope.load()

  getPurchase = (params) ->

    deferred = $q.defer()
    PurchaseService.query(params).then (purchase) ->
      deferred.resolve(purchase)
      purchase.$get('company').then (company) =>
        setPurchaseCompany(company)
      $scope.purchase = purchase
      $scope.bb.purchase = purchase
      $scope.price = !($scope.purchase.price == 0)
    , (err) -> #get purchase
      loader.setLoaded()
      if err && err.status == 401
        if LoginService.isLoggedIn()
          # TODO don't show fail message, display message that says you're logged in as someone else and offer switch user function (logout and show login)
          failMsg()
        else
          loginRequired()
      else
        failMsg()
    return deferred.promise

  getBookings = (purchase) ->

    $scope.purchase.$getBookings().then (bookings) ->
      $scope.bookings = bookings

      if bookings[0]
        bookings[0].$getCompany().then (company) ->
          $scope.purchase.bookings[0].company = company
          if company.$has("reasons")
            getReasons(company).then (reasons) ->
              setCancelReasons()
              setMoveReasons()
              setMoveReasonsToBB()
              setCancelReasonsToBB()
          company.$getAddress().then (address) ->
            $scope.purchase.bookings[0].company.address = address

      loader.setLoaded()
      checkIfMoveBooking(bookings)
      checkIfWaitlistBookings(bookings)

      for booking in $scope.bookings
        booking.$getAnswers().then (answers) ->
          booking.answers = answers
    , (err) -> #get booking
      loader.setLoaded()
      failMsg()

    if purchase.$has('client')
      purchase.$get('client').then (client) =>
        $scope.setClient(new BBModel.Client(client))
    $scope.purchase.getConfirmMessages().then (messages) ->
      $scope.purchase.confirm_messages = messages
      $scope.messages = messages

  $scope.load = (id) ->

    loader.notLoaded()

    id = getPurchaseID() if !id

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

          getPurchase(params).then (purchase) ->
            $scope.bb.purchase = purchase
            getBookings(purchase)

        , (err) ->  loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
      , (err) ->  loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    else
      loader.setLoaded()

    $scope.loaded = true


  checkIfMoveBooking = (bookings) ->

    matches = /^.*(?:\?|&)move_booking=(.*?)(?:&|$)/.exec($location.absUrl())
    id = parseInt(matches[1]) if matches
    if id
      move_booking = (b for b in bookings when b.id == id)
      $scope.move(move_booking[0]) if move_booking.length > 0 && $scope.isMovable(bookings[0])

  checkIfWaitlistBookings = (bookings) ->

    $scope.waitlist_bookings = (booking for booking in bookings when (booking.on_waitlist && booking.settings.sent_waitlist == 1))


  loginRequired = () =>

    if !$scope.bb.login_required
      window.location = window.location.href + "&login=true"


  getCompanyID = () ->

    matches = /^.*(?:\?|&)company_id=(.*?)(?:&|$)/.exec($location.absUrl())
    company_id = matches[1] if matches
    company_id


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


  $scope.bookWaitlistItem = (booking) ->
    loader.notLoaded()

    params =
      purchase: $scope.purchase
      booking: booking
    PurchaseService.bookWaitlistItem(params).then (purchase) ->
      $scope.purchase = purchase
      $scope.total = $scope.purchase
      $scope.bb.purchase = purchase
      $scope.purchase.$getBookings().then (bookings) ->
        $scope.bookings = bookings
        $scope.waitlist_bookings = (booking for booking in $scope.bookings when (booking.on_waitlist and booking.settings.sent_waitlist is 1))
        if $scope.purchase.$has('new_payment') and $scope.purchase.due_now > 0
          $scope.make_payment = true
        loader.setLoaded()
      , (err) ->
        loader.setLoaded()
        failMsg()

    , (err) =>
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong')


  # delete a single booking
  $scope.delete = (booking) ->

    modalInstance = $uibModal.open
      templateUrl: $scope.getPartial "_cancel_modal"
      controller: ModalDelete
      resolve:
        booking: -> booking
        cancel_reasons: -> $scope.cancel_reasons

    modalInstance.result.then (booking) ->
      loader.notLoaded()
      cancel_reason = null
      cancel_reason = booking.cancel_reason if booking.cancel_reason
      data = {cancel_reason: cancel_reason}
      booking.$del('self', {}, data).then (service) =>
        loader.setLoaded()
        $scope.bookings = _.without($scope.bookings, booking)
        $rootScope.$broadcast "booking:cancelled"


  # delete all bookings assoicated to the purchase
  $scope.deleteAll = () ->

    modalInstance = $uibModal.open
      templateUrl: $scope.getPartial "_cancel_modal"
      controller: ModalDeleteAll
      resolve:
        purchase: -> $scope.purchase
    modalInstance.result.then (purchase) ->
      loader.notLoaded()
      PurchaseService.deleteAll(purchase).then (purchase) ->
        loader.setLoaded()
        $scope.purchase = purchase
        $scope.bookings = []
        $rootScope.$broadcast "booking:cancelled"


  $scope.isMovable = (booking) ->

    if booking.min_cancellation_time
      return moment().isBefore(booking.min_cancellation_time)
    booking.datetime.isAfter(moment())

  $scope.createBasketItem = (booking) ->

    item = new BBModel.BasketItem(booking, $scope.bb)
    item.setSrcBooking(booking)
    return item


  $scope.checkAnswer = (answer) ->

    typeof answer.value == 'boolean' || typeof answer.value == 'string' || typeof answer.value == "number"


  $scope.changeAttendees = (route) ->
    $scope.moveAll(route)

  getReasons = (company) ->

    ReasonService.query(company).then (reasons) ->
      $scope.company_reasons = reasons
      $scope.company_reasons
    , (err) ->
      loader.setLoadedAndShowError(err, 'Sorry, something went wrong retrieving reasons')

  setCancelReasons = () ->

    $scope.cancel_reasons = _.filter($scope.company_reasons, (r) -> r.reason_type == 3)
    $scope.cancel_reasons

  setMoveReasons = () ->

    $scope.move_reasons = _.filter($scope.company_reasons, (r) -> r.reason_type == 5)
    $scope.move_reasons

  setMoveReasonsToBB = () ->

    $scope.bb.move_reasons = $scope.move_reasons if $scope.move_reasons

  setCancelReasonsToBB = () ->
    
    $scope.bb.cancel_reasons = $scope.cancel_reasons if $scope.cancel_reasons


# Simple modal controller for handling the 'delete' modal
ModalDelete = ($scope,  $rootScope, $uibModalInstance, booking, AlertService, cancel_reasons) ->
  $scope.booking = booking
  $scope.cancel_reasons = cancel_reasons

  $scope.confirmDelete = () ->
    AlertService.clear()
    $uibModalInstance.close(booking)

  $scope.cancel = ->
    $uibModalInstance.dismiss "cancel"

# Simple modal controller for handling the 'delete all' modal
ModalDeleteAll = ($scope,  $rootScope, $uibModalInstance, purchase) ->
  $scope.purchase = purchase

  $scope.confirmDelete = () ->
    $uibModalInstance.close(purchase)

  $scope.cancel = ->
    $uibModalInstance.dismiss "cancel"
