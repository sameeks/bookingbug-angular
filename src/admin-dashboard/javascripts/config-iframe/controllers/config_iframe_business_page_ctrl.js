/*
* @ngdoc controller
* @name BBAdminDashboard.config-iframe.controllers.controller:ConfigIframeBusinessPageCtrl
*
* @description
* Controller for the config page
*/
angular.module('BBAdminDashboard.config-iframe.controllers')
.controller('ConfigIframeBusinessPageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {
  $scope.pageHeader = 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TITLE';

  $scope.tabs = [
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TAB_STAFF',
      icon: 'fa fa-male',
      path: 'config.business.page({path: "person"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TAB_RESOURCES',
      icon: 'fa fa-diamond',
      path: 'config.business.page({path: "resource"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TAB_SERVICES',
      icon: 'fa fa-wrench',
      path: 'config.business.page({path: "service"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TAB_WHO_WHAT_WHERE',
      icon: 'fa fa-question-circle',
      path: 'config.business.page({path: "grid"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BUSINESS.TAB_QUEUES',
      icon: 'fa fa-users',
      path: 'config.business.page({path: "client_queue"})'
    }
  ];

  $scope.contentsLoading = false;

  $scope.$on('iframeLoaded', function(){
    $scope.contentsLoading = false;
    return $scope.$apply();
  });

  return $scope.$on('iframeLoading', ()=> $scope.contentsLoading = true);
}
]);