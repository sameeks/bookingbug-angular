'use strict'

angular.module('BBAdminDashboard.config-iframe.controllers', [])
angular.module('BBAdminDashboard.config-iframe.services', [])
angular.module('BBAdminDashboard.config-iframe.directives', [])
angular.module('BBAdminDashboard.config-iframe.translations', [])

angular.module('BBAdminDashboard.config-iframe', [
  'BBAdminDashboard.config-iframe.controllers',
  'BBAdminDashboard.config-iframe.services',
  'BBAdminDashboard.config-iframe.directives',
  'BBAdminDashboard.config-iframe.translations'
])
.run ['RuntimeStates', 'AdminConfigIframeOptions', 'SideNavigationPartials', (RuntimeStates, AdminConfigIframeOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminConfigIframeOptions.use_default_states

    RuntimeStates
      .state 'config',
        parent: AdminConfigIframeOptions.parent_state
        url: '/config'
        templateUrl: 'admin_config_page.html'
        controller: 'ConfigIframePageCtrl'
        deepStateRedirect: {
          default: {
            state:  'config.page'
            params: {
              path: 'resource'
            }
          }
        }

      .state 'config.page',
        url: '/page/:path'
        templateUrl: 'iframe_page.html'
        controller: 'ConfigSubIframePageCtrl'

  if AdminConfigIframeOptions.show_in_navigation 
    SideNavigationPartials.addPartialTemplate('config-iframe', 'config-iframe/nav.html')       
]  