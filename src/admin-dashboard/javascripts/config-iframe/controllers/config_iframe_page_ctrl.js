/*
* @ngdoc controller
* @name BBAdminDashboard.config-iframe.controllers.controller:ConfigIframePageCtrl
*
* @description
* Controller for the config page
*/
angular.module('BBAdminDashboard.config-iframe.controllers')
.controller('ConfigIframePageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {

  $scope.parent_state = $state.is("config");
  $scope.path = "edit";

  return $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    $scope.parent_state = false;
    if (toState.name === "config") {
      return $scope.parent_state = true;
    }
  });
}
]);