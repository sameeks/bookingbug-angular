angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope) ->
  templateUrl: 'member_past_bookings.html'
  scope:
    apiUrl: '@'
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    getBookings = () ->
      scope.getPastBookings()

    scope.$watch 'member', () ->
      getBookings() if !scope.past_bookings

    $rootScope.connection_started.then () ->
      getBookings
