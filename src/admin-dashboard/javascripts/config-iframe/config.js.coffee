'use strict'

angular.module('BBAdminDashboard.config-iframe.controllers', [])
angular.module('BBAdminDashboard.config-iframe.services', [])
angular.module('BBAdminDashboard.config-iframe.directives', [])

angular.module('BBAdminDashboard.config-iframe', [
  'BBAdminDashboard.config-iframe.controllers',
  'BBAdminDashboard.config-iframe.services',
  'BBAdminDashboard.config-iframe.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'config',
      parent: "root"
      url: "/config"
      templateUrl: "admin_config_page.html"
      controller: "ConfigIframePageCtrl"

    .state 'config.page',
      url: "/page/:path"
      templateUrl: "iframe_page.html"
      controller: 'ConfigSubIframePageCtrl'
]