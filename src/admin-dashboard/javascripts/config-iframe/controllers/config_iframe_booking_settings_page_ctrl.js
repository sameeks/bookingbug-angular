/*
* @ngdoc controller
* @name BBAdminDashboard.config-iframe.controllers.controller:ConfigIframeBookingSettingsPageCtrl
*
* @description
* Controller for the config page
*/
angular.module('BBAdminDashboard.config-iframe.controllers')
.controller('ConfigIframeBookingSettingsPageCtrl',['$scope', '$state', '$rootScope', function($scope, $state, $rootScope) {
  $scope.pageHeader = 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TITLE';

  $scope.tabs = [
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TAB_QUESTIONS',
      icon: 'fa fa-question-circle',
      path: 'config.booking-settings.page({path: "detail_type"})'
    },
    {
       name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TAB_QUESTION_GROUPS',
       icon: 'fa fa-question-circle',
       path: 'config.booking-settings.page({path: "detail_group"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TAB_BOOKING_TEXT',
      icon: 'fa fa-file-text',
      path: 'config.booking-settings.page({path: "conf/text/text_edit"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TAB_ADDRESSES',
      icon: 'fa fa-building-o',
      path: 'config.booking-settings.page({path: "address"})'
    },
    {
      name: 'ADMIN_DASHBOARD.CONFIG_IFRAME_PAGE.BOOKING_SETTINGS.TAB_IMAGES',
      icon: 'fa fa-picture-o',
      path: 'config.booking-settings.page({path: "media/image/all"})'
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