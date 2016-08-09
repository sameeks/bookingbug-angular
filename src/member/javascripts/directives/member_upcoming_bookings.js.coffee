angular.module('BBMember').directive 'bbMemberUpcomingBookings', ($rootScope, BBModel, PurchaseService) ->
  templateUrl: 'member_upcoming_bookings.html'
  scope:
    member: '='
    notLoaded: '='
    setLoaded: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->
  
    scope.upcoming_bookings = new BBModel.Pagination({page_size: 10, max_size: 5, request_page_size: 10})

    getBookings = (params) ->
      scope.getUpcomingBookings(params).then (collection) ->
        scope.upcoming_bookings.initialise(collection.items, collection.total_entries)


    scope.$on 'updateBookings', () ->
      scope.flushBookings()
      getBookings()


    scope.$watch 'member', () ->
      getBookings() if !scope.upcoming_bookings.items


    $rootScope.connection_started.then () ->
      getBookings()


    scope.pageChanged = () ->

      [items_present, page_to_load] = scope.upcoming_bookings.update()

      if !items_present
        params =
          page: page_to_load
        scope.getBookings(params, {add: true})
