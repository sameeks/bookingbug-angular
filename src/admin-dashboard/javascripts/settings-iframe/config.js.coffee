'use strict'

angular.module('BBAdminDashboard.settings-iframe.controllers', [])
angular.module('BBAdminDashboard.settings-iframe.services', [])
angular.module('BBAdminDashboard.settings-iframe.directives', [])

angular.module('BBAdminDashboard.settings-iframe', [
  'BBAdminDashboard.settings-iframe.controllers',
  'BBAdminDashboard.settings-iframe.services',
  'BBAdminDashboard.settings-iframe.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'settings',
      parent: "root"
      url: "/settings"
      templateUrl: "admin_settings_page.html"
      deepStateRedirect: {
        default: { state: "settings.page", params: { path: "person" } }
        params: true
      }
      
    .state 'settings.page',
      parent: "settings"
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: 'SettingsSubIframePageCtrl'
]