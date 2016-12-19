angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService) ->

	vm = @

	loader = LoadingService.$loader($scope)

	
	$scope.initMove = (basketItem, route) ->
    # open modal if moving public basketItem from purchase template
    if route is 'modal' 
      total_id = QueryStringService('id')
      openCalendarModal(basketItem, total_id)

    # else just move the basketItem
    else readyBasketItem(basketItem, route)


  readyBasketItem = (basketItem, route) ->
    loader.notLoaded()
    confirming = true
    basketItem.moved_booking = false
    basketItem.setAskedQuestions()

    if basketItem.move_reason
      basketItem.move_reason = $scope.bb.current_item.move_reason

    if basketItem.ready
      moveBooking(basketItem, route)
    else 
      $scope.decideNextPage(route)


  moveBooking = (basketItem, route) ->
    if $scope.bb.moving_purchase
      updatePurchase(basketItem, route)
    else
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
      PurchaseService.purchase = $scope.bb.purchase
      purchaseBooking.move_done = true
      resolveCalendarModal(b)
     , (err) =>
      loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  # updates all bookings found in purchase
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
    $rootScope.$broadcast("booking:moved", booking)

    # if modal is already open just load confirmation template
    if WidgetModalService.is_open and WidgetModalService.config.member
      $scope.decideNextPage('confirmation')
    # if using studio interface load purchase 
    else if $rootScope.user
      $scope.decideNextPage('purchase')
    else 
      WidgetModalService.close() 
    showMoveMessage(booking.datetime)
