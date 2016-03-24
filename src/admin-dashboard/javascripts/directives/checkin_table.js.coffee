
angular.module('BBAdminDashboard').directive 'bbCheckinTable', () ->
  restrict: 'AE'
  replace: false
  scope : true
  templateUrl: 'checkin_table.html'
  controller : 'CheckinsController'
  link : (scope, element, attrs) ->
    return

angular.module('BBAdminDashboard').controller 'CheckinsController', ($scope,  $rootScope,
    BusyService, $q, $filter, AdminTimeService, AdminBookingService,
    AdminSlotService, $timeout, AlertService) ->

  $scope.getAppointments = (currentPage, filterBy, filterByFields, orderBy, orderByReverse) ->
    if filterByFields && filterByFields.name?
      filterByFields.name = filterByFields.name.replace(/\s/g, '')
    if filterByFields && filterByFields.mobile?
      mobile = filterByFields.mobile
      if mobile.indexOf('0') == 0
        filterByFields.mobile = mobile.substring(1)
    defer = $q.defer()
    params =
      company: $scope.company
      date: moment().format('YYYY-MM-DD')
      url: $scope.bb.api_url
    params.filter_by = filterBy if filterBy
    params.filter_by_fields = filterByFields if filterByFields
    params.order_by = orderBy if orderBy
    params.order_by_reverse = orderByReverse if orderByReverse
    AdminBookingService.query(params).then (res) =>
      $scope.booking_collection = res
      $scope.bookings = []
      $scope.bmap = {}
      for item in res.items
        if item.status != 3 # not blocked
          $scope.bookings.push(item.id)
          $scope.bmap[item.id] = item
      # update the items if they've changed
      $scope.booking_collection.addCallback $scope, (booking, status) =>
        $scope.bookings = []
        $scope.bmap = {}
        for item in $scope.booking_collection.items
          if item.status != 3 # not blocked
            $scope.bookings.push(item.id)
            $scope.bmap[item.id] = item
      defer.resolve($scope.bookings)
    , (err) ->
      defer.reject(err)
    defer.promise

  $scope.setStatus = (booking, status) =>
    booking.current_multi_status = status
    booking.$update(booking).then (res) ->
      $scope.booking_collection.checkItem(res)
    , (err) ->
      AlertService.danger({msg: 'Something went wrong'})


  @checker = () =>
    $timeout () =>
      # do nothing - this will cause an apply anyway
      @checker()
    , 1000

  $scope.getAppointments()

  @checker()
