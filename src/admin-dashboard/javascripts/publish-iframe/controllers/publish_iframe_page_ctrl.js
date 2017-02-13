// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc controller
* @name BBAdminDashboard.publish-iframe.controllers.controller:PublishIframePageCtrl
*
* @description
* Controller for the publish page
*/
angular.module('BBAdminDashboard.publish-iframe.controllers')
.controller('PublishIframePageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {

  $scope.parent_state = $state.is("publish");
  $scope.path = "conf";

  return $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams) {
    $scope.parent_state = false;
    if (toState.name === "setting") {
      return $scope.parent_state = true;
    }
  });
}
]);