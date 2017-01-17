'use strict'

moveBookingCtrl =  ($scope, $rootScope, $attrs, BBModel, LoadingService, PurchaseService, PurchaseBookingService, AlertService, GeneralOptions, $translate, MemberBookingService, WidgetModalService, QueryStringService, $window) ->

  vm = @

  init = () ->
    vm.loader = LoadingService.$loader($scope)
    vm.options = $scope.$eval($attrs.bbMoveBooking) or {}

  ###**
  * @ngdoc method
  * @name initMove
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Decide whether bookings should be moved in modal
  *
  * @param {array|object} bookings The booking or bookings to be moved
  * @param {string} totalId The total id associated with the bookings being moved (optional)
  ###

  vm.initMove = (bookings, totalId) ->
    # open modal if moving public bookings from purchase template
    # totalId is either passed in from the template or if on view_booking page take from the url
    if vm.options.openCalendarInModal 
      totalId = QueryStringService('id') if !totalId
      openCalendarModal(bookings, totalId)

    # else just start moving the bookings
    else decideNumberOfBookings(bookings)


  ###**
  * @ngdoc method
  * @name decideNumberOfBookings
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Decide whether we are moving an array of bookings or a single booking
  *
  * @param {array|object} bookings The basket item or bookings to be moved
  ###

  decideNumberOfBookings = (bookings) ->
    if bookings.length > 1 
      checkMultipleBookings(bookings)

    else checkSingleBooking(bookings)


  ###**
  * @ngdoc method
  * @name checkMultipleBookings
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Check if all bookings in bookings array are ready to be moved 
  *
  * @param {array} bookings The array of bookings to be moved
  ###

  checkMultipleBookings = (bookings) ->
    if !bookings[0].datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    readyBookings = []

    # check if each bookings questions have been answered
    for booking in bookings 
      if booking.setAskedQuestions() is true
        readyBookings.push booking 

    $scope.bb.movingPurchase = $scope.bb.purchase

    # only update puchase if all booking questions are answered
    updatePurchase(bookings) if readyBookings.length is bookings.length


  ###**
  * @ngdoc method
  * @name checkSingleBooking
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Check if single booking is ready to be moved
  *
  * @param {object} basketItem The booking to be moved
  ###

  checkSingleBooking = (basketItem) ->
    if !basketItem.datetimeHasChanged() 
      AlertService.add("warning", { msg: "Your booking is already scheduled for that time." })
      return

    # only move purchase once any questions have been answered
    basketItem.setAskedQuestions() 
    updatePurchaseBooking(basketItem) if basketItem.ready


  ###**
  * @ngdoc method
  * @name updatePurchaseBooking
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Move single booking in purchase 
  *
  * @param {object} basketItem The booking to be moved
  ###

  updatePurchaseBooking = (basketItem) ->
    vm.loader.notLoaded()
    PurchaseBookingService.update(basketItem).then (purchaseBooking) ->
      booking = new BBModel.Purchase.Booking(purchaseBooking)
      vm.loader.setLoaded()

      # update the total purchase with the new booking
      if $scope.bb.purchase
        for oldb, _i in $scope.bb.purchase.bookings
          $scope.bb.purchase.bookings[_i] = booking if oldb.id is booking.id

      resolveCalendarModal(booking)
    , (err) =>
      vm.loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  ###**
  * @ngdoc method
  * @name updatePurchase
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Move all bookings in purchase
  *
  * @param {array} bookings The bookings to be moved
  ###

  updatePurchase = (bookings) ->
    vm.loader.notLoaded()
    params =
      purchase: $scope.bb.movingPurchase
      bookings: bookings
    if bookings[0].move_reason
      params.move_reason = bookings[0].move_reason 
    PurchaseService.update(params).then (purchase) ->
      $scope.bb.purchase = purchase
      $scope.bb.purchase.$getBookings().then (bookings)->
        $scope.purchase = purchase 
        vm.loader.setLoaded()
        resolveCalendarModal(bookings)

    , (err) ->
      vm.loader.setLoaded()
      AlertService.add("danger", { msg: "Failed to move booking. Please try again." })


  ###**
  * @ngdoc method
  * @name openCalendarModal
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * initialise widget in modal and render calendar or multi_service_calendar template
  *
  * @param {array} bookings The bookings to be moved
  * @param {string} totalId The total id associated with the bookings being moved (optional)
  ###

  openCalendarModal = (bookings, totalId) ->
    # open multi_service_calendar template when moving multiple bookings at once 
    WidgetModalService.open
      company_id: if bookings.length > 0 then bookings[0].company_id else bookings.company.id
      template: 'main_view_booking'
      total_id: totalId
      first_page: if bookings.length > 0 then 'multi_service_calendar' else 'calendar'


  ###**
  * @ngdoc method
  * @name resolveCalendarModal
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Decide what template to render after booking has been moved, close modal if needed
  *
  * @param {array} bookings The bookings to be moved
  ###

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


  ###**
  * @ngdoc method
  * @name decideMoveMessage
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * Get relevent datetime from updated bookings
  *
  * @param {array|object} bookings The bookings being moved
  ###

  decideMoveMessage = (bookings) ->
    if bookings.length > 1
      datetime = bookings[0].datetime
    else 
      datetime = bookings.datetime
    showMoveMessage(datetime)


  ###**
  * @ngdoc method
  * @name showMoveMessage
  * @methodOf BB.Directives:bbMoveBooking
  * @description
  * show alert with updated booking time
  *
  * @param {object} datetime The new booking datetime
  ###

  showMoveMessage = (datetime) ->
    if GeneralOptions.use_i18n 
      $translate('MOVE_BOOKINGS_MSG', { datetime:datetime.format('LLLL') }).then (translated_text) ->
      AlertService.add("info", { msg: translated_text })
    else
      AlertService.add("info", { msg: "Your booking has been moved to #{datetime.format('LLLL')}" }) 

    $window.scroll(0, 0)

  init()
  

angular.module('BB.Controllers').controller 'MoveBookingCtrl', moveBookingCtrl