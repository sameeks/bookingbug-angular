'use strict'

angular.module('BBAdminDashboard.dashboard-iframe.controllers', [])
angular.module('BBAdminDashboard.dashboard-iframe.services', [])
angular.module('BBAdminDashboard.dashboard-iframe.directives', [])

angular.module('BBAdminDashboard.dashboard-iframe', [
  'BBAdminDashboard.dashboard-iframe.controllers',
  'BBAdminDashboard.dashboard-iframe.services',
  'BBAdminDashboard.dashboard-iframe.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'dashboard',
      parent: "root"
      url: "/dashboard"
      controller: "DashboardIframePageCtrl"
      templateUrl: "admin_dashboard_page.html"

    .state 'dashboard.page',
      parent: "dashboard"
      url: "/page/:path"
      controller: 'DashboardSubIframePageCtrl'
      templateUrl: "iframe_page.html"
]