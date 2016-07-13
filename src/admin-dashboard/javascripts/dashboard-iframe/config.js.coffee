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
.run ['RuntimeStates', 'AdminDashboardIframeOptions', 'SideNavigationPartials', (RuntimeStates, AdminDashboardIframeOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminDashboardIframeOptions.use_default_states

    RuntimeStates
      .state 'dashboard',
        parent: AdminDashboardIframeOptions.parent_state
        url: "/dashboard"
        controller: "DashboardIframePageCtrl"
        templateUrl: "dashboard-iframe/index.html"
        deepStateRedirect: {
          default: {
            state:  'dashboard.page'
            params: {
              path: 'view/dashboard/index'
              fixed: true
            }
          }
        }

      .state 'dashboard.page',
        url: "/page/:path"
        controller: 'DashboardSubIframePageCtrl'
        templateUrl: "core/iframe-page.html"

  if AdminDashboardIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('dashboard-iframe', 'dashboard-iframe/nav.html')
]