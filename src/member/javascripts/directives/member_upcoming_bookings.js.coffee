angular.module('BBMember').directive 'bbMemberUpcomingBookings', ($rootScope, BBModel) ->
  templateUrl: 'member_upcoming_bookings.html'
  scope:
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.pagination = BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 100})

    getBookings = () ->
      scope.getUpcomingBookings().then (upcoming_bookings) ->
        scope.pagination.num_items = upcoming_bookings.length
        scope.pagination.update()


    scope.$on 'updateBookings', () ->
      scope.flushBookings()
      getBookings()


    scope.$watch 'member', () ->
      getBookings() if !scope.upcoming_bookings


    $rootScope.connection_started.then () ->
      getBookings()

