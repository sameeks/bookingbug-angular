angular.module('BBMember').directive 'bbMemberPrePaidBookings', ($rootScope) ->
  templateUrl: 'member_pre_paid_bookings.html'
  scope:
    apiUrl: '@'
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    scope.loading = true

    getBookings = () ->
      scope.getPrePaidBookings({}).finally () ->
        scope.loading = false


    scope.$watch 'member', () ->
      getBookings() if !scope.pre_paid_bookings


    $rootScope.connection_started.then () ->
      getBookings()
