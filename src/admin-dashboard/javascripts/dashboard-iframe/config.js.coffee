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
.run ['RuntimeStates', 'AdminDashboardIframeOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminDashboardIframeOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminDashboardIframeOptions.use_default_states

    RuntimeStates
      .state 'dashboard',
        parent: AdminDashboardIframeOptions.parent_state
        url: "dashboard"
        controller: "DashboardIframePageCtrl"
        template: ()->
          $templateCache.get('dashboard-iframe/index.html')
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.environment == 'development'
              script = 'bb-angular-admin-dashboard-dashboard-iframe.lazy.js'
            else
              script = 'bb-angular-admin-dashboard-dashboard-iframe.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }
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
        template: ()->
          $templateCache.get('core/iframe-page.html')

  if AdminDashboardIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('dashboard-iframe', 'core/nav/dashboard-iframe.html')
]