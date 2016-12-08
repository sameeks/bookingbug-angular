angular.module('BB.Directives').directive 'bbMoveBooking', () ->
	restrict: 'AE'
	controller: 'MoveBooking'

angular.module('BB.Controllers').controller 'MoveBooking', ($scope, $rootScope, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService) ->

	vm = @

	loader = LoadingService.$loader($scope)

	
	$scope.moveBooking = (booking, route) ->
		confirmMove(booking, route)

	confirmMove = (booking, route) ->
	  confirming = true
	  booking.moved_booking = false
	  # we need to validate the question information has been correctly entered here
	  booking.setAskedQuestions()

	  if booking.ready
	    loader.notLoaded()
	    if $scope.bb.moving_purchase
	    	updatePurchase(booking, route)
	    else
	    	updatePurchaseBooking(booking, route)
	  else
	    $scope.decideNextPage(route)



	updatePurchaseBooking = (purchase, route) ->
    if purchase.move_reason
      purchase.move_reason = $scope.bb.current_item.move_reason
    PurchaseBookingService.update(purchase).then (booking) ->
      b = new BBModel.Purchase.Booking(booking)

      if $scope.bb.purchase
        for oldb, _i in $scope.bb.purchase.bookings
          $scope.bb.purchase.bookings[_i] = b if oldb.id == b.id

      loader.setLoaded()
      $scope.bb.moved_booking = booking
      purchase.move_done = true
      $rootScope.$broadcast "booking:moved"
      $scope.decideNextPage(route)
      showMoveMessage(b.datetime)
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
        $rootScope.$broadcast "booking:moved"
        $scope.decideNextPage(route)
        showMoveMessage(bookings[0].datetime)

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