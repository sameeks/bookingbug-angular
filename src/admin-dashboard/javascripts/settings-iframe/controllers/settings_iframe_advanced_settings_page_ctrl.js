/*
* @ngdoc controller
* @name BBAdminDashboard.settings-iframe.controllers.controller:SettingsIframeAdvancedSettingsPageCtrl
*
* @description
* Controller for the settings page
*/
angular.module('BBAdminDashboard.settings-iframe.controllers')
.controller('SettingsIframeAdvancedSettingsPageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {
  $scope.pageHeader = 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.ADVANCED_SETTINGS.TITLE';

  $scope.tabs = [
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.ADVANCED_SETTINGS.TAB_ONLINE_PAYMENTS',
      icon: 'fa fa-credit-card',
      path: 'settings.advanced-settings.page({path: "conf/payment/payment_edit"})'
    },
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.ADVANCED_SETTINGS.TAB_ACCOUNTING_INTEGRATIONS',
      icon: 'fa fa-pencil-square-o',
      path: 'settings.advanced-settings.page({path: "conf/accounting/accounting_integration"})'
    },
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.ADVANCED_SETTINGS.TAB_BUSINESS_QUESTIONS',
      icon: 'fa fa-question',
      path: 'settings.advanced-settings.page({path: "conf/extra_question"})'
    },
    {
      name: 'ADMIN_DASHBOARD.SETTINGS_IFRAME_PAGE.ADVANCED_SETTINGS.TAB_API_SETTINGS',
      icon: 'fa fa-code',
      path: 'settings.advanced-settings.page({path: "conf/developer/parameter"})'
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