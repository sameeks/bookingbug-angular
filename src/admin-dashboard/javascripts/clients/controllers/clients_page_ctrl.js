(function () {

    /*
     * @ngdoc controller
     * @name BBAdminDashboard.clients.controllers.controller:ClientsPageCtrl
     *
     * @description
     * Controller for the clients page
     */

    angular
        .module('BBAdminDashboard.clients.controllers')
        .controller('ClientsPageCtrl', ClientsPageCtrl);

    function ClientsPageCtrl($scope, $state) {
        $scope.clientsOptions = {search: null};
        return $scope.set_current_client = client => $scope.current_client = client;
    }

})();

