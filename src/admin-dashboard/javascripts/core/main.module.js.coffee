'use strict'

angular.module('BBAdminDashboard', [
  'ngStorage',
  'ngResource',
  'ngTouch',
  'ngSanitize',
  'ngLocalData',
  'ngCookies',

  'BBAdmin',
  'BBAdminServices',
  'BBAdminBooking',
  'BBAdmin.Directives',
  'BBMember',

  'ui.calendar',
  'ui.bootstrap',
  'ui.router',
  'ct.ui.router.extras',
  'trNgGrid',
  'toggle-switch',
  'pascalprecht.translate',
  'angular-loading-bar',
  'ngScrollable',
  'toastr',

  'BBAdminDashboard.check-in',
  'BBAdminDashboard.clients',
  'BBAdminDashboard.login',
  'BBAdminDashboard.logout',
  'BBAdminDashboard.reset-password',
  'BBAdminDashboard.calendar',
  'BBAdminDashboard.dashboard-iframe',
  'BBAdminDashboard.members-iframe',
  'BBAdminDashboard.settings-iframe',
  'BBAdminDashboard.config-iframe',
  'BBAdminDashboard.publish-iframe'
])


