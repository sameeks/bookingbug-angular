
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
    if filterByFields.name?
      filterByFields.name = filterByFields.name.replace(/\s/g, '')
    if filterByFields.mobile?
      mobile = filterByFields.mobile
      if mobile.indexOf('0') == 0
        filterByFields.mobile = mobile.substring(1)
      
    promise = $q.defer()

    AdminBookingService.query({company_id: $scope.bb.company_id, date: moment().format('YYYY-MM-DD'), filter_by: filterBy, filter_by_fields: filterByFields, order_by: orderBy, order_by_reverse: orderByReverse}).then (bookings) =>
      $scope.bookings = bookings.items
      $scope.total_entries = bookings.total_entries
      promise.resolve(bookings.items)
    , (err) ->
      promise.reject(err)

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