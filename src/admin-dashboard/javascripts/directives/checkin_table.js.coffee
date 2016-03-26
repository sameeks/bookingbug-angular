
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

  $scope.sorter = "unixTime"

  $scope.doSort = (sorter) =>
    if sorter == $scope.sorter && $scope.sortAscending?
      $scope.sortAscending = !$scope.sortAscending
    else
      $scope.sortAscending = true

    $scope.sorter = sorter
    $scope.bookings = $filter('orderBy')($scope.bookings, (item) =>
      $scope.bmap[item][sorter]
    , !$scope.sortAscending)

    return false

  $scope.loadAppointments = () =>

    BusyService.notLoaded $scope
    prms = { company_id: $scope.bb.company_id, date: moment().format('YYYY-MM-DD') }
    prms.url = $scope.bb.api_url

    AdminBookingService.query(prms).then (res) =>
      $scope.booking_collection = res
      $scope.bookings = []
      $scope.bmap = {}
      for item in res.items
        item.unixTime = item.datetime.unix()
        if item.status != 3 # not blocked
          $scope.bookings.push(item.id)
          $scope.bmap[item.id] = item
      $scope.doSort($scope.sorter)
      BusyService.setLoaded $scope
      BusyService.setPageLoaded($scope)
      # update the items if they've changed
      $scope.booking_collection.addCallback $scope, (booking, status) =>
        $scope.bookings = []
        $scope.bmap = {}
        for item in $scope.booking_collection.items
          item.unixTime = item.datetime.unix()
          if item.status != 3 # not blocked
            $scope.bookings.push(item.id)
            $scope.bmap[item.id] = item
        $scope.doSort($scope.sorter)


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

  @checker()

  $scope.loadAppointments()

