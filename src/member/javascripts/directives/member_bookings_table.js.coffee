angular.module('BBMember').directive 'memberBookingsTable', ($uibModal, $log, $rootScope, MemberLoginService, MemberBookingService, $compile, $templateCache, ModalForm, BBModel, Dialog) ->

  controller = ($scope, $uibModal) ->

    $scope.loading = true

    $scope.fields ||= ['date_order', 'details']

    $scope.$watch 'member', (member) ->
      getBookings($scope, member) if member?

    $scope.edit = (id) ->
      booking = _.find $scope.booking_models, (b) -> b.id == id
      booking.getAnswersPromise().then (answers) ->
        for answer in answers.answers
          booking["question#{answer.question_id}"] = answer.value
        ModalForm.edit
          model: booking
          title: 'Booking Details'
          templateUrl: 'edit_booking_modal_form.html'
          success: (b) ->
            b = new BBModel.Member.Booking(b)
            i =_.indexOf($scope.booking_models, (b) -> b.id == id)
            $scope.booking_models[i] = b
            $scope.setRows()

    $scope.cancel = (id) ->
      booking = _.find $scope.booking_models, (b) -> b.id == id

      modalInstance = $uibModal.open
        templateUrl: 'member_bookings_table_cancel_booking.html'
        controller: ($scope, $uibModalInstance, booking) ->
          $scope.booking = booking
          $scope.booking.notify = true
          $scope.ok = () ->
            $uibModalInstance.close($scope.booking)
          $scope.close = () ->
            $uibModalInstance.dismiss()
        scope: $scope
        resolve:
          booking: () -> booking

      modalInstance.result.then (booking) ->
        $scope.loading = true
        params =
          notify: booking.notify
        booking.$post('cancel', params).then () ->
          i =_.findIndex($scope.booking_models, (b) -> console.log(b); b.id == booking.id)
          $scope.booking_models.splice(i, 1)
          $scope.setRows()
          $scope.loading = false

    $scope.setRows = () ->
      $scope.bookings = _.map $scope.booking_models, (booking) ->
        id: booking.id
        date: moment(booking.datetime).format('YYYY-MM-DD')
        date_order: moment(booking.datetime).format('x')
        datetime: moment(booking.datetime)
        details: booking.full_describe

    getBookings = ($scope, member) ->
      params =
        start_date : $scope.startDate.format('YYYY-MM-DD')
        start_time : $scope.startTime.format('HH:mm') if $scope.startTime
        end_date   : $scope.endDate.format('YYYY-MM-DD') if $scope.endDate
        end_time   : $scope.endTime.format('HH:mm') if $scope.endTime

      MemberBookingService.query(member, params).then (bookings) ->
        $scope.booking_models = bookings
        $scope.setRows()
        $scope.loading = false
      , (err) ->
        $log.error err.data
        $scope.loading = false

    $scope.startDate ||= moment()

    $scope.orderBy = $scope.defaultOrder
    if not $scope.orderBy?
      $scope.orderBy = 'date_order'

    $scope.now = moment()

    getBookings($scope, $scope.member) if $scope.member

  {
    controller: controller
    templateUrl: 'member_bookings_table.html'
    scope:
      apiUrl:       '@'
      fields:       '=?'
      member:       '='
      startDate:    '=?'
      startTime:    '=?'
      endDate:      '=?'
      endTime:      '=?'
      defaultOrder: '=?'
  }
