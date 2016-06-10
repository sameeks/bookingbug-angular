angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope, BBModel) ->
  templateUrl: 'member_past_bookings.html'
  scope:
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.pagination = BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 100})

    getBookings = () ->
      scope.getPastBookings().then (past_bookings) ->
        scope.pagination.num_items = past_bookings.length
        scope.pagination.update()


    scope.$watch 'member', () ->
      getBookings() if !scope.past_bookings


    $rootScope.connection_started.then () ->
      getBookings()
