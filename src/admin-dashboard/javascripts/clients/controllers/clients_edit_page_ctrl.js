// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc controller
 * @name BBAdminDashboard.clients.controllers.controller:ClientsEditPageCtrl
 *
 * @description
 * Controller for the clients edit page
 */
angular.module('BBAdminDashboard.clients.controllers')
    .controller('ClientsEditPageCtrl', function ($scope, client, $state, company, BBModel) {

        $scope.client = client;
        $scope.historicalStartDate = moment().add(-1, 'years');
        $scope.historicalEndDate = moment();
        // Refresh Client Resource after save
        return $scope.memberSaveCallback = function () {
            let params = {
                company_id: company.id,
                id: $state.params.id,
                flush: true
            };

            return BBModelAdmin.Client.$query(params).then(client => $scope.client = client);
        };
    });

