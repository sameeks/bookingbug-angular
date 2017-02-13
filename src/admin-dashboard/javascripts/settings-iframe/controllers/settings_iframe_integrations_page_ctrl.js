/*
* @ngdoc controller
* @name BBAdminDashboard.settings-iframe.controllers.controller:SettingsIframeIntegrationsPageCtrl
*
* @description
* Controller for the settings page
*/
angular.module('BBAdminDashboard.settings-iframe.controllers')
.controller('SettingsIframeIntegrationsPageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {
  $scope.pageHeader = 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.INTEGRATIONS.TITLE';

  $scope.tabs = [
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.INTEGRATIONS.TAB_PAYMENT',
      icon: 'fa fa-credit-card',
      path: 'settings.integrations.page({path: "conf/addons/payment"})'
    },
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.INTEGRATIONS.TAB_ACCOUNTING',
      icon: 'fa fa-pencil-square-o',
      path: 'settings.integrations.page({path: "conf/addons/accounting"})'
    },
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.INTEGRATIONS.TAB_OTHER',
      icon: 'fa fa-question',
      path: 'settings.integrations.page({path: "conf/addons/other"})'
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