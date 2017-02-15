/*
 * @ngdoc controller
 * @name BBAdminDashboard.clients.controllers.controller:ClientsPageCtrl
 *
 * @description
 * Controller for the clients page
 */
angular.module('BBAdminDashboard.clients.controllers')
    .controller('ClientsPageCtrl', ['$scope', '$state', function ($scope, $state) {

        $scope.clientsOptions = {search: null};

        return $scope.set_current_client = client => $scope.current_client = client;
    }

    ]);
