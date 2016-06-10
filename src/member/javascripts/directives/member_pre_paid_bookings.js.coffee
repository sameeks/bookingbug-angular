angular.module('BBMember').directive 'bbMemberPrePaidBookings', ($rootScope, BBModel) ->
  templateUrl: 'member_pre_paid_bookings.html'
  scope:
    member: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.pagination = BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 100})

    getBookings = () ->
      scope.getPrePaidBookings({}).then (pre_paid_bookings) ->
        scope.pagination.num_items = pre_paid_bookings.length
        scope.pagination.update()


    scope.$watch 'member', () ->
      getBookings() if !scope.pre_paid_bookings


    scope.$on "booking:cancelled", (event) ->
      scope.getPrePaidBookings({}).then (pre_paid_bookings) ->
        scope.pagination.num_items = pre_paid_bookings.length
        scope.pagination.update()


    $rootScope.connection_started.then () ->
      getBookings()
