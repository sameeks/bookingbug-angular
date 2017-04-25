(function () {

    /*
     * @ngdoc controller
     * @name BBAdminDashboard.clients.controllers.controller:ClientsAllPageCtrl
     *
     * @description
     * Controller for the clients all page
     */


    angular
        .module('BBAdminDashboard.clients.controllers')
        .controller('ClientsAllPageCtrl', ClientsAllPageCtrl);

    function ClientsAllPageCtrl($scope, $state) {
        return $scope.set_current_client(null);
    }

})();
