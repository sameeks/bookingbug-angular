/*
 * @ngdoc controller
 * @name BBAdminDashboard.clients.controllers.controller:ClientsEditPageCtrl
 *
 * @description
 * Controller for the clients edit page
 */
angular
    .module('BBAdminDashboard.clients.controllers')
    .controller('ClientsEditPageCtrl', ClientsEditPageCtrl);


function ClientsEditPageCtrl($scope, client, $state, company, BBModel, $rootScope) {
    $scope.client = client;
    $scope.historicalStartDate = moment().add(-1, 'years');
    $scope.historicalEndDate = moment();
    // Refresh Client Resource after save
    return $scope.memberSaveCallback = function () {
        let params = {
            company: $rootScope.bb.company,
            id: $state.params.id,
            flush: true
        };

        return BBModel.Admin.Client.$query(params).then(client => $scope.client = client);
    };
};


