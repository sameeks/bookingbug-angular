angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope, PaginationService) ->

  templateUrl: 'member_past_bookings.html'
  scope:
    member: '='
    notLoaded: '='
    setLoaded: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})

    getBookings = () ->
      scope.getPastBookings().then (past_bookings) ->
        if past_bookings
          PaginationService.update(scope.pagination, past_bookings.length)


    scope.$watch 'member', () ->
      getBookings() if scope.member && !scope.past_bookings


    getBookings() if scope.member
