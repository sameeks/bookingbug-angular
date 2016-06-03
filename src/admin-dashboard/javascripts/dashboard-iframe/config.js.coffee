'use strict'

angular.module('BBAdminDashboard.dashboard-iframe.controllers', [])
angular.module('BBAdminDashboard.dashboard-iframe.services', [])
angular.module('BBAdminDashboard.dashboard-iframe.directives', [])
angular.module('BBAdminDashboard.dashboard-iframe.translations', [])

angular.module('BBAdminDashboard.dashboard-iframe', [
  'BBAdminDashboard.dashboard-iframe.controllers',
  'BBAdminDashboard.dashboard-iframe.services',
  'BBAdminDashboard.dashboard-iframe.directives',
  'BBAdminDashboard.dashboard-iframe.translations'
])
.run ['RuntimeStates', 'AdminDashboardIframeOptions', (RuntimeStates, AdminDashboardIframeOptions) ->
  # Choose to opt out of the default routing
  if AdminDashboardIframeOptions.use_default_states

    RuntimeStates
      .state 'dashboard',
        parent: AdminDashboardIframeOptions.parent_state
        url: "/dashboard"
        controller: "DashboardIframePageCtrl"
        templateUrl: "admin_dashboard_page.html"

      .state 'dashboard.page',
        url: "/page/:path"
        controller: 'DashboardSubIframePageCtrl'
        templateUrl: "iframe_page.html"  
]  