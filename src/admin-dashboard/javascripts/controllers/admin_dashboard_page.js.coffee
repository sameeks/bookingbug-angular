angular.module('BBAdminDashboard').controller 'bbAdminDashboardPageController', ($scope, $sce, $state, $rootScope, $window, AdminBookingPopup) ->

  $scope.parent_state = $state.is("view")
  $scope.bb.side_menu = "dashboard_menu"
  $scope.path = "view/dashboard/index"
  $window.addEventListener 'message', (event) =>
    if event && event.data
      if event.data.type && event.data.type == "booking"
        AdminBookingPopup.open
          size: 'lg'
          company_id: $scope.bb.company.id
          item_defaults:
            date: event.data.date
            time: event.data.iarray * 5
            person: event.data.person
            resource: event.data.resource

