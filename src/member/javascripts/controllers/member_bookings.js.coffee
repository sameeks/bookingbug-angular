angular.module('BBMember').controller 'MemberBookings', ($scope, $modal, $log, MemberBookingService, $q, ModalForm, MemberPrePaidBookingService) ->

  $scope.loading = true


  $scope.getUpcomingBookings = () ->
    params =
      start_date: moment().format('YYYY-MM-DD')
    getBookings(params).then (bookings) ->
      $scope.upcoming_bookings = bookings


  $scope.getPastBookings = (num, type) ->
    # default to year in the past if no amount is specified
    if num and type
      date = moment().subtract(num, type)
    else
      date = moment().subtract(1, 'year')
    params =
      start_date: date.format('YYYY-MM-DD')
      end_date: moment().format('YYYY-MM-DD')
    getBookings(params).then (bookings) ->

      $scope.past_bookings = _.chain(bookings)
        .filter((b) -> b.datetime.isBefore(moment()))
        .sortBy((b) -> -b.datetime.unix())
        .value()

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
    defer.promise


  $scope.cancelBooking = (booking) ->
    $scope.loading = true
    MemberBookingService.cancel($scope.member, booking).then () ->
      
      $scope.$emit("cancel:success")

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
      $log.error err.data
      $scope.loading = false
    defer.promise
