angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope, PaginationService) ->
  templateUrl: 'member_past_bookings.html'
  scope:
    apiUrl: '@'
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    $rootScope.bb ||= {}
    $rootScope.bb.api_url ||= scope.apiUrl
    $rootScope.bb.api_url ||= "http://www.bookingbug.com"

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})

    getBookings = () ->
      scope.getPastBookings().then (past_bookings) ->
        PaginationService.update(scope.pagination, past_bookings.length)


    scope.$watch 'member', () ->
      getBookings() if !scope.past_bookings


    $rootScope.connection_started.then () ->
      getBookings()
