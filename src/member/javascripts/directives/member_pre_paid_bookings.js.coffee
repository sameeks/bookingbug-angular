angular.module('BBMember').directive 'bbMemberPrePaidBookings', ($rootScope, PaginationService) ->

  templateUrl: 'member_pre_paid_bookings.html'
  scope:
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5})

    getBookings = () ->
      scope.getPrePaidBookings({}).then (pre_paid_bookings) ->
        PaginationService.update(scope.pagination, pre_paid_bookings.length)


    scope.$watch 'member', () ->
      getBookings() if !scope.pre_paid_bookings


    scope.$on "booking:cancelled", (event) ->
      scope.getPrePaidBookings({}).then (pre_paid_bookings) ->
        PaginationService.update(scope.pagination, pre_paid_bookings.length)


    $rootScope.connection_started.then () ->
      getBookings()
