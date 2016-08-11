angular.module('BBMember').directive 'bbMemberPastBookings', ($rootScope, PaginationService) ->
  templateUrl: 'member_past_bookings.html'
  scope:
    member: '='
    notLoaded: '='
    setLoaded: '='
  controller: 'MemberBookings'
  link: (scope, element, attrs) ->

    scope.paginator = new BBModel.Pagination({page_size: 10, max_size: 5})

    getBookings = (params, options = {}) ->
      params = params or {}
      params.per_page = params.per_page or scope.paginator.request_page_size
      scope.getPastBookings(params).then (collection) ->
        if options.add
          scope.paginator.add(params.page, collection.items)
        else
          scope.paginator.initialise(collection.items, collection.total_entries)



    scope.$watch 'member', () ->
      getBookings() if !scope.paginator.items


    $rootScope.connection_started.then () ->
      getBookings()


    scope.pageChanged = () ->

      [items_present, page_to_load] = scope.paginator.update()

      if !items_present
        params =
          page: page_to_load
        getBookings(params, {add: true})

