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

        let checkNameAndEmail = function (newVal, oldVal) {
          if (typeof newVal === 'undefined' && oldVal === '') {
            $scope.$broadcast('schemaForm.error.first_name', 'nameOrEmail', true);
            $scope.$broadcast('schemaForm.error.last_name', 'nameOrEmail', true);
            $scope.$broadcast('schemaForm.error.email', 'nameOrEmail', true);
          }
          let attributes = [
            $scope.client.first_name,
            $scope.client.last_name,
            $scope.client.email
          ];
          if (_.every(attributes, _.isEmpty)) {
            $scope.$broadcast('schemaForm.error.first_name', 'nameOrEmail', 'Either a name or email address is required');
            $scope.$broadcast('schemaForm.error.last_name', 'nameOrEmail', 'Either a name or email address is required');
            $scope.$broadcast('schemaForm.error.email', 'nameOrEmail', 'Either a name or email address is required');
          } else {
            $scope.$broadcast('schemaForm.error.first_name', 'nameOrEmail', true);
            $scope.$broadcast('schemaForm.error.last_name', 'nameOrEmail', true);
            $scope.$broadcast('schemaForm.error.email', 'nameOrEmail', true);
            $scope.$broadcast('schemaForm.error.email', 'default', true);

          }
        };

        $scope.$watch('client.first_name', checkNameAndEmail);
        $scope.$watch('client.last_name', checkNameAndEmail);
        $scope.$watch('client.email', checkNameAndEmail);

        // Refresh Client Resource after save
        return $scope.memberSaveCallback = function () {
            let params = {
                company: company,
                company_id: company.id,
                id: $state.params.id,
                flush: true
            };

            return BBModel.Admin.Client.$query(params).then(client => $scope.client = client);
        };
    });

