angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService) ->

	vm = @

	loader = LoadingService.$loader($scope)

	
	$scope.initMove = (booking, route) ->
    # open modal if moving public booking from purchase template
    if route = 'modal' and !WidgetModalService.is_open
      total_id = QueryStringService('id')
      openCalendarModal(booking, total_id)

    # else just move the booking
    else readyBooking(booking, route)


  readyBooking = (booking, route) ->
    confirming = true
    booking.moved_booking = false
    booking.setAskedQuestions()

    if booking.move_reason
      booking.move_reason = $scope.bb.current_item.move_reason

    if booking.ready
      moveBooking(booking, route)
    else 
      $scope.decideNextPage(route)


  moveBooking = (booking, route) ->
    if $scope.bb.moving_purchase
      updatePurchase(booking, route)
    else
      updatePurchaseBooking(booking, route)



	updatePurchaseBooking = (purchase, route) ->
    PurchaseBookingService.update(purchase).then (booking) ->
      b = new BBModel.Purchase.Booking(booking)

      if $scope.bb.purchase
        for oldb, _i in $scope.bb.purchase.bookings
          $scope.bb.purchase.bookings[_i] = b if oldb.id == b.id

      loader.setLoaded()
      $scope.bb.moved_booking = booking
      purchase.move_done = true
      resolveCalendarModal(b)
     , (err) =>
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })

	updatePurchase = (booking, route) ->
    params =
      purchase: $scope.bb.moving_purchase
      bookings: $scope.bb.basket.items
    if booking.move_reason
      params.move_reason = booking.move_reason 
    PurchaseService.update(params).then (purchase) ->
      $scope.bb.purchase = purchase
      $scope.bb.purchase.$getBookings().then (bookings)->
        $scope.purchase = purchase
        loader.setLoaded()
        booking.move_done = true
        booking.moved_booking = true
        resolveCalendarModal(bookings[0])

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
    WidgetModalService.open
      company_id: booking.company.id
      template: 'main_view_booking'
      total_id: total_id
      first_page: 'calendar'

  resolveCalendarModal = (booking) ->
      $rootScope.$broadcast "booking:moved"
      # dont close modal and render purchase template if moving member booking
      if WidgetModalService.config.member
        $scope.decideNextPage('confirmation')
      else 
        WidgetModalService.close() 
      showMoveMessage(booking.datetime)
