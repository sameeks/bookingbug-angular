angular.module('BBMember').directive 'memberBookingsTable', ($modal, $log, $rootScope,
    MemberLoginService, MemberBookingService, $compile, $templateCache) ->

  controller = ($scope, $modal) ->

    $scope.loading = true

    $scope.fields ||= ['describe', 'full_describe']

    $scope.$watch 'member', (member) ->
      getBookings($scope, member) if member?

    $scope.edit = (id) ->
      booking = _.find $scope.booking_models, (b) -> b.id == id
      $modal.open
        templateUrl: 'edit_booking_modal_form.html'
        controller: 'editBookingModalForm'
        resolve:
          booking: () -> booking

    getBookings = ($scope, member) ->
      params =
        start_date: moment().format('YYYY-MM-DD')
      MemberBookingService.query(member, params).then (bookings) ->
        $scope.booking_models = bookings
        $scope.bookings = _.map bookings, (booking) ->
          _.pick booking, 'id', 'full_describe', 'describe'
        $scope.loading = false
      , (err) ->
        $log.error err.data
        $scope.loading = false

  link = (scope, element, attrs) ->
    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

  {
    link: link
    controller: controller
    templateUrl: 'member_bookings_table.html'
    scope:
      apiUrl: '@'
      fields: '=?'
      member: '='
  }
