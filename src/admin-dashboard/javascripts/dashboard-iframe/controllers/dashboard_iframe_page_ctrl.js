/*
* @ngdoc controller
* @name BBAdminDashboard.dashboard-iframe.controllers.controller:DashboardIframePageCtrl
*
* @description
* Controller for the dashboard page
*/
angular.module('BBAdminDashboard.dashboard-iframe.controllers')
.controller('DashboardIframePageCtrl',['$scope', '$state', '$window', 'AdminBookingPopup', function($scope, $state, $window, AdminBookingPopup) {
  $scope.parent_state = $state.is("view");
  $scope.bb.side_menu = "dashboard_menu";
  $scope.path = "view/dashboard/index";
  return $window.addEventListener('message', event => {
    if (event && event.data) {
      if (event.data.type && (event.data.type === "booking")) {
        return AdminBookingPopup.open({
          size: 'lg',
          company_id: $scope.bb.company.id,
          on_conflict: "cancel()",
          item_defaults: {
            date: event.data.date,
            time: event.data.iarray * 5,
            person: event.data.person,
            resource: event.data.resource
          }
        });
      }
    }
  }
  );
}
]);