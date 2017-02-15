/*
 * @ngdoc controller
 * @name BBAdminDashboard.members-iframe.controllers.controller:MembersIframePageCtrl
 *
 * @description
 * Controller for the members page
 */
angular.module('BBAdminDashboard.members-iframe.controllers')
    .controller('MembersIframePageCtrl', ['$scope', '$state', '$rootScope', '$window', function ($scope, $state, $rootScope, $window) {

        $scope.parent_state = $state.is("members");

        $rootScope.$on('$stateChangeStart', function (event, toState, toParams, fromState, fromParams) {
            $scope.parent_state = false;
            if (toState.name === "members") {
                $scope.parent_state = true;
                return $scope.clearCurrentClient();
            }
        });

        $scope.setCurrentClient = function (client) {
            if (client) {
                $rootScope.client_id = client;
                return $scope.extra_params = `id=${client}`;
            } else {
                return $scope.clearCurrentClient();
            }
        };

        $scope.clearCurrentClient = function () {
            $rootScope.client_id = null;
            return $scope.extra_params = "";
        };

        return $window.addEventListener('message', event => {
            if (event && event.data) {
                if (event.data.controller === "client") {
                    if (event.data.id) {
                        $scope.setCurrentClient(event.data.id);
                    }
                    if (event.data.action === "single") {
                        return $state.go("members.page", {path: 'client/single', id: event.data.id});
                    }
                }
            }
        });
    }
    ]);
