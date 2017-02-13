/*
* @ngdoc controller
* @name BBAdminDashboard.config-iframe.controllers.controller:ConfigSubIframePageCtrl
*
* @description
* Controller for the config sub page
*/
angular.module('BBAdminDashboard.config-iframe.controllers')
.controller('ConfigSubIframePageCtrl',['$scope', '$state', '$stateParams', function($scope, $state, $stateParams) {
  $scope.path = $stateParams.path;
  $scope.pageHeader = null;

  $scope.$emit('iframeLoading',{});

  return $scope.onIframeLoad = ()=> $scope.$emit('iframeLoaded',{});
}

]);