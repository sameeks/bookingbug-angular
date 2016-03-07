angular.module('BBMember').directive 'bbMemberUpcomingBookings', ($rootScope, PaginationService) ->
  templateUrl: 'member_upcoming_bookings.html'
  scope:
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->
    
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
      
