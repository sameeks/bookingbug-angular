angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService) ->

	loader = LoadingService.$loader($scope)

	
	$scope.initMove = (bookings, route) ->
    # open modal if moving public bookings from purchase template
    if route is 'modal' 
      total_id = QueryStringService('id')
      openCalendarModal(bookings, total_id)

    # else just start moving the bookings
    else decideNumberOfBookings(bookings, route)


  decideNumberOfBookings = (bookings, route) ->
    loader.notLoaded()
    if bookings.length > 1 
      moveMultipleBookings(bookings, route)

    else if typeof bookings is 'array' and bookings.length is 1
      moveSingleBooking(bookings[0])

    else moveSingleBooking(bookings)


  moveMultipleBookings = (bookings, route) ->
    $scope.bb.moving_purchase = $scope.bb.purchase
    updatePurchase(bookings, route)
    

  moveSingleBooking = (basketItem, route) ->
    confirming = true
    basketItem.moved_booking = false
    if basketItem.setAskedQuestions()
      basketItem.setAskedQuestions() 
    if basketItem.move_reason
      basketItem.move_reason = $scope.bb.current_item.move_reason

    updatePurchaseBooking(basketItem, route)


  # updates single srcBooking of purchase
	updatePurchaseBooking = (basketItem, route) ->
    PurchaseBookingService.update(basketItem).then (purchaseBooking) ->
      b = new BBModel.Purchase.Booking(purchaseBooking)


      if $scope.bb.purchase
        for oldb, _i in $scope.bb.purchase.bookings
          $scope.bb.purchase.bookings[_i] = b if oldb.id == b.id


      loader.setLoaded()
      $scope.bb.moved_booking = purchaseBooking
      purchaseBooking.move_done = true
      resolveCalendarModal(b)
     , (err) =>
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  # updates all bookings found in purchase
	updatePurchase = (bookings, route) ->
    params =
      purchase: $scope.bb.moving_purchase
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

	showMoveMessage = (datetime) ->
	  # TODO remove whem translate enabled by default
	  if GeneralOptions.use_i18n 
	    $translate('MOVE_BOOKINGS_MSG', { datetime:datetime.format('LLLL') }).then (translated_text) ->
	      AlertService.add("info", { msg: translated_text })
	  else
	    AlertService.add("info", { msg: "Your booking has been moved to #{datetime.format('LLLL')}" })


  openCalendarModal = (booking, total_id) ->
    if booking.length > 0 
      booking = booking[0]
      WidgetModalService.open
        company_id: booking.company.id
        template: 'main_view_booking'
        total_id: total_id
        first_page: 'multi_service_calendar'
    else 
      WidgetModalService.open
        company_id: booking.company.id
        template: 'main_view_booking'
        total_id: total_id
        first_page: 'calendar'

  resolveCalendarModal = (bookings) ->
    $rootScope.$broadcast("booking:moved", bookings)

    # if modal is already open just load confirmation template
    if WidgetModalService.is_open and WidgetModalService.config.member
      $scope.decideNextPage('confirmation')
    # if using studio interface load purchase 
    else if $rootScope.user
      $scope.decideNextPage('purchase')
    else 
      WidgetModalService.close() 
    showMoveMessage(bookings.datetime) if typeof bookings is 'object'
