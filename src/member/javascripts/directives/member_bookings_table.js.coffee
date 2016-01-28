angular.module('BBMember').directive 'memberBookingsTable', ($modal, $log,
    $rootScope, MemberLoginService, MemberBookingService, $compile,
    $templateCache, ModalForm, BBModel, Dialog) ->

  controller = ($scope, $modal) ->

    $scope.loading = true

    $scope.fields ||= ['datetime', 'details']

    $scope.$watch 'member', (member) ->
      getBookings($scope, member) if member?

    $scope.edit = (id) ->
      booking = _.find $scope.booking_models, (b) -> b.id == id
      booking.$getAnswers().then (answers) ->
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

      modalInstance = $modal.open
        templateUrl: 'member_bookings_table_cancel_booking.html'
        controller: ($scope, $modalInstance, booking) ->
          $scope.booking = booking
          $scope.booking.notify = true
          $scope.ok = () ->
            $modalInstance.close($scope.booking)
          $scope.close = () ->
            $modalInstance.dismiss()
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
        datetime: moment(booking.datetime).format('ddd DD MMM YY HH:mm')
        details: booking.full_describe

    getBookings = ($scope, member) ->
      params =
        start_date: $scope.startDate.format('YYYY-MM-DD')
        end_date: $scope.endDate.format('YYYY-MM-DD') if $scope.endDate
      MemberBookingService.query(member, params).then (bookings) ->
        $scope.booking_models = bookings
        $scope.setRows()
        $scope.loading = false
      , (err) ->
        $log.error err.data
        $scope.loading = false

    $scope.startDate ||= moment()

    $scope.orderBy ||= 'datetime'

    $scope.now = moment().format('YYYY-MM-DD')

    getBookings($scope, $scope.member) if $scope.member

  {
    controller: controller
    templateUrl: 'member_bookings_table.html'
    scope:
      apiUrl: '@'
      fields: '=?'
      member: '='
      startDate: '=?'
      endDate: '=?'
  }
