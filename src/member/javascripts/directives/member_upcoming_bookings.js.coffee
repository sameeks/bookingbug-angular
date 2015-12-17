angular.module('BBMember').directive 'bbMemberUpcomingBookings', ($rootScope, PaginationService) ->
  templateUrl: 'member_upcoming_bookings.html'
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
      scope.getUpcomingBookings().then (upcoming_bookings) ->
        PaginationService.update(scope.pagination, upcoming_bookings.length)


    scope.$on 'updateBookings', () ->
      scope.flushBookings()
      getBookings()


    scope.$watch 'member', () ->
      getBookings() if !scope.upcoming_bookings


    $rootScope.connection_started.then () ->
      getBookings()
      