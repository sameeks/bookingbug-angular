'use strict'

angular.module('BBAdminDashboard.bookings.directives').directive 'bbBookingsTable', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'TabletBookings'
  link : (scope, element, attrs) ->
    return


angular.module('BBAdminDashboard.bookings.directives').controller 'TabletBookings', ($scope,  $rootScope, $q, AdminBookingService, AlertService) ->
  $scope.clientDef = $q.defer()
  $scope.clientPromise = $scope.clientDef.promise
  $scope.per_page = 15
  $scope.total_entries = 0
  $scope.bookings = []

  $scope.getBookings = (currentPage, filterBy, filterByFields, orderBy, orderByReverse) ->
    if filterByFields.name?
      filterByFields.name = filterByFields.name.replace(/\s/g, '')
    if filterByFields.mobile?
      mobile = filterByFields.mobile
      if mobile.indexOf('0') == 0
        filterByFields.mobile = mobile.substring(1)

    clientDef = $q.defer()

    # BusyService.notLoaded $scope
    AdminBookingService.query({company_id:$scope.bb.company.id, per_page: $scope.per_page, page: currentPage+1, filter_by: filterBy, filter_by_fields: filterByFields, order_by: orderBy, order_by_reverse: orderByReverse    }).then (clients) =>
      $scope.bookings = bookings.items
      # BusyService.setLoaded $scope
      # BusyService.setPageLoaded()
      $scope.total_entries = bookings.total_entries
      clientDef.resolve(bookings.items)
    , (err) ->
      clientDef.reject(err)
      # BusyService.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')

