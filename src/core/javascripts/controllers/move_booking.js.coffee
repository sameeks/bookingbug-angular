angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, $attrs, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService, $window) ->

  loader = LoadingService.$loader($scope)
  $scope.options = $scope.$eval($attrs.bbMoveBooking) or {}

  $scope.initMove = (bookings, totalId) ->
    # open modal if moving public bookings from purchase template
    # totalId is either passed in from the template or if on view_booking page take from the url
    if $scope.options.openCalendarInModal 
      totalId = QueryStringService('id') if !totalId
      openCalendarModal(bookings, totalId)

    # else just start moving the bookings
    else decideNumberOfBookings(bookings)


  decideNumberOfBookings = (bookings) ->
    if bookings.length > 1 
      moveMultipleBookings(bookings)

    else moveSingleBooking(bookings)


  moveMultipleBookings = (bookings) ->
    if !bookings[0].datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    readyBookings = []

    for booking in bookings 
      if booking.setAskedQuestions() is true
        readyBookings.push booking 

    $scope.bb.movingPurchase = $scope.bb.purchase
    updatePurchase(bookings) if readyBookings.length is bookings.length


  moveSingleBooking = (basketItem) ->
    if !basketItem.datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    basketItem.setAskedQuestions() 

    updatePurchaseBooking(basketItem) if basketItem.ready


  # updates single srcBooking of purchase
  updatePurchaseBooking = (basketItem) ->
    loader.notLoaded()
    PurchaseBookingService.update(basketItem).then (purchaseBooking) ->
      booking = new BBModel.Purchase.Booking(purchaseBooking)
      loader.setLoaded()

      if $scope.bb.purchase
        for oldb, _i in $scope.bb.purchase.bookings
          $scope.bb.purchase.bookings[_i] = booking if oldb.id is booking.id

      resolveCalendarModal(booking)
    , (err) =>
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  # updates all bookings found in purchase
  updatePurchase = (bookings) ->
    loader.notLoaded()
    params =
      purchase: $scope.bb.movingPurchase
      bookings: bookings
    if bookings[0].move_reason
      params.move_reason = bookings[0].move_reason 
    PurchaseService.update(params).then (purchase) ->
      $scope.bb.purchase = purchase
      $scope.bb.purchase.$getBookings().then (bookings)->
        $scope.purchase = purchase 
        loader.setLoaded()
        resolveCalendarModal(bookings)

    , (err) ->
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  openCalendarModal = (bookings, totalId) ->
    # open multi_service_calendar template when moving multiple bookings at once 
    WidgetModalService.open
      company_id: if bookings.length > 0 then bookings[0].company_id else bookings.company.id
      template: 'main_view_booking'
      total_id: totalId
      first_page: if bookings.length > 0 then 'multi_service_calendar' else 'calendar'


  resolveCalendarModal = (bookings) ->
    $rootScope.$broadcast("booking:moved", $scope.bb.purchase)

    # if modal is already open just load confirmation template
    if WidgetModalService.isOpen and WidgetModalService.config.member
      $scope.decideNextPage('confirmation')
      # if using studio interface load purchase 
    else if $rootScope.user
      $scope.decideNextPage('purchase')
    else 
      WidgetModalService.close() 
      decideMoveMessage(bookings) 


  decideMoveMessage = (bookings) ->
    return if !bookings?

    if bookings.length > 1
      datetime = bookings[0].datetime
    else 
      datetime = bookings.datetime
    showMoveMessage(datetime)


  showMoveMessage = (datetime) ->
    if GeneralOptions.use_i18n 
      $translate('MOVE_BOOKINGS_MSG', { datetime:datetime.format('LLLL') }).then (translated_text) ->
      AlertService.add("info", { msg: translated_text })
    else
      AlertService.add("info", { msg: "Your booking has been moved to #{datetime.format('LLLL')}" }) 

    $window.scroll(0, 0)
