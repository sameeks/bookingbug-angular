angular.module('BBMember').controller 'MemberBookings', ($scope, $modal, $log, MemberBookingService, $q, ModalForm, MemberPrePaidBookingService, $rootScope, AlertService, PurchaseService) ->

  $scope.loading = true


  $scope.getUpcomingBookings = () ->

    defer = $q.defer()

    params =
      start_date: moment().format('YYYY-MM-DD')
    getBookings(params).then (upcoming_bookings) ->
      $scope.upcoming_bookings = upcoming_bookings
      defer.resolve(upcoming_bookings)
    , (err) ->
      defer.reject([])

    return defer.promise


  $scope.getPastBookings = (num, type) ->

    defer = $q.defer()

    # default to year in the past if no amount is specified
    if num and type
      date = moment().subtract(num, type)
    else
      date = moment().subtract(1, 'year')
    params =
      start_date: date.format('YYYY-MM-DD')
      end_date: moment().add(1,'day').format('YYYY-MM-DD')
    getBookings(params).then (past_bookings) ->

      $scope.past_bookings = _.chain(past_bookings)
        .filter((b) -> b.datetime.isBefore(moment()))
        .sortBy((b) -> -b.datetime.unix())
        .value()

      defer.resolve(past_bookings)
    , (err) ->
      defer.reject([])

    return defer.promise


  $scope.flushBookings = () ->
    params =
      start_date: moment().format('YYYY-MM-DD')
    MemberBookingService.flush($scope.member, params)


  $scope.edit = (booking) ->
    booking.getAnswersPromise().then (answers) ->
      for answer in answers.answers
        booking["question#{answer.question_id}"] = answer.value
      ModalForm.edit
        model: booking
        title: 'Booking Details'
        templateUrl: 'edit_booking_modal_form.html'
        windowClass: 'member_edit_booking_form'
        success: updateBookings


  updateBookings = () ->
    $scope.getUpcomingBookings()


  $scope.cancel = (booking) ->
    modalInstance = $modal.open
      templateUrl: "member_booking_delete_modal.html"
      windowClass: "bbug"
      controller: ($scope, $rootScope, $modalInstance, booking) ->
        $scope.controller = "ModalDelete"
        $scope.booking = booking

        $scope.confirm_delete = () ->
          $modalInstance.close(booking)

        $scope.cancel = ->
          $modalInstance.dismiss "cancel"
      resolve:
        booking: ->
          booking
    modalInstance.result.then (booking) ->
      $scope.cancelBooking(booking)


  getBookings = (params) ->
    $scope.loading = true
    defer = $q.defer()
    MemberBookingService.query($scope.member, params).then (bookings) ->
      $scope.loading = false
      defer.resolve(bookings)
    , (err) ->
      $log.error err.data
      $scope.loading = false
    return defer.promise


  $scope.cancelBooking = (booking) ->
    $scope.loading = true
    MemberBookingService.cancel($scope.member, booking).then () ->
      
      $rootScope.$broadcast("booking:cancelled")

      removeBooking = (booking, bookings) ->
        return bookings.filter (b) -> b.id != booking.id

      $scope.past_bookings = removeBooking(booking, $scope.past_bookings) if $scope.past_bookings
      $scope.upcoming_bookings = removeBooking(booking, $scope.upcoming_bookings) if $scope.upcoming_bookings

      # does a removeBooking method exist in the scope chain?
      $scope.removeBooking(booking) if $scope.removeBooking
      $scope.loading = false


  $scope.getPrePaidBookings = (params) ->
    
    $scope.loading = true
    defer = $q.defer()

    MemberPrePaidBookingService.query($scope.member, params).then (bookings) ->
      $scope.loading = false
      $scope.pre_paid_bookings = bookings
      defer.resolve(bookings)
    , (err) ->
      defer.reject([])
      $log.error err.data
      $scope.loading = false

    return defer.promise


  $scope.book = (booking) ->

    # TODO build actions lsit based on type of booking
    
    $scope.loading = true

    params =
      purchase_id: booking.purchase_ref
      url_root: $rootScope.bb.api_url
      booking: booking

    PurchaseService.bookWaitlistItem(params).then (purchase_total) ->
      if purchase_total.due_now > 0 
        if purchase_total.$has('new_payment')
          openPaymentModal(booking, purchase_total)
        else
          $log.error "total is missing new_payment link, this is usually caused by online payment not being configured correctly"
      else
        bookWaitlistSucces()
        
      $scope.loading = false


  bookWaitlistSucces = () ->
    AlertService.success({msg: "You're booking is now confirmed!"})
    updateBookings()


  openPaymentModal = (booking, total) ->
    modalInstance = $modal.open
      templateUrl: "booking_payment_modal.html"
      windowClass: "bbug"
      size: "lg"
      controller: ($scope, $rootScope, $modalInstance, booking, total, PurchaseService) ->
        
        $scope.booking = booking
        $scope.total = total

        $scope.handlePaymentSuccess = () ->
          $modalInstance.close(booking)

        $scope.cancel = ->
          $modalInstance.dismiss "cancel"
    
      resolve:
        booking: -> booking
        total: -> total

    modalInstance.result.then (booking) ->
      bookWaitlistSucces()

