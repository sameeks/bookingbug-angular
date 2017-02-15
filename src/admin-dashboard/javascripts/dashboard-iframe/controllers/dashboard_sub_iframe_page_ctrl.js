/*
 * @ngdoc controller
 * @name BBAdminDashboard.dashboard-iframe.controllers.controller:DashboardSubIframePageCtrl
 *
 * @description
 * Controller for the dashboard sub page
 */
angular.module('BBAdminDashboard.dashboard-iframe.controllers')
    .controller('DashboardSubIframePageCtrl', ['$scope', '$state', '$stateParams', function ($scope, $state, $stateParams) {
        $scope.path = $stateParams.path;

        if ($scope.path === 'view/dashboard/index') {
            return $scope.fullHeight = true;
        }
    }
    ]);
