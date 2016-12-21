angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, $attrs, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService, $window) ->

  loader = LoadingService.$loader($scope)
  $scope.options = $scope.$eval($attrs.bbMoveBooking) or {}

  $scope.initMove = (bookings, route) ->
    # open modal if moving public bookings from purchase template
    if $scope.options.openCalendarInModal 
      total_id = QueryStringService('id')
      openCalendarModal(bookings, total_id)

    # else just start moving the bookings
    else decideNumberOfBookings(bookings, route)


  decideNumberOfBookings = (bookings, route) ->
    if bookings.length > 1 
      moveMultipleBookings(bookings, route)

    else moveSingleBooking(bookings)


  moveMultipleBookings = (bookings, route) ->
    if !bookings[0].datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    $scope.bb.movingPurchase = $scope.bb.purchase
    updatePurchase(bookings, route)


  moveSingleBooking = (basketItem, route) ->
    # set ready to false until we check setAskedQuestions
    basketItem.ready = false

    if !basketItem.datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    basketItem.setAskedQuestions() 

    updatePurchaseBooking(basketItem, route) if basketItem.ready


  # updates single srcBooking of purchase
  updatePurchaseBooking = (basketItem, route) ->
    loader.notLoaded()
    PurchaseBookingService.update(basketItem).then (purchaseBooking) ->
      booking = new BBModel.Purchase.Booking(purchaseBooking)
      loader.setLoaded()
      $scope.bb.moved_booking = purchaseBooking
      resolveCalendarModal(booking)
    , (err) =>
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  # updates all bookings found in purchase
  updatePurchase = (bookings, route) ->
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


  openCalendarModal = (bookings, total_id) ->
    # booking is either a single basket item or an array of bookings 
    if bookings.length > 0 
      # open multi_service_calendar template when moving multiple bookings at once 
      WidgetModalService.open
        company_id: bookings[0].company.id
        template: 'main_view_booking'
        total_id: total_id
        first_page: 'multi_service_calendar'
    else 
      # else just load the normal calendar template 
      WidgetModalService.open
        company_id: bookings.company.id
        template: 'main_view_booking'
        total_id: total_id
        first_page: 'calendar'


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
