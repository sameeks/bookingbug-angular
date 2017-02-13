// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc controller
* @name BBAdminDashboard.members-iframe.controllers.controller:MembersSubIframePageCtrl
*
* @description
* Controller for the members sub page
*/
angular.module('BBAdminDashboard.members-iframe.controllers')
.controller('MembersSubIframePageCtrl',['$scope', '$state', '$stateParams', function($scope, $state, $stateParams) {
  $scope.path = $stateParams.path;
  if ($stateParams.id) {
    $scope.extra_params = `id=${$stateParams.id}`;
  } else {
    $scope.extra_params = "";
  }

  $scope.loading = true;
  return $scope.$on('iframeLoaded', function(){
  	$scope.loading = false;
  	return $scope.$apply();
  });
}
]);