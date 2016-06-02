'use strict'

angular.module('BBAdminDashboard.settings-iframe.controllers', [])
angular.module('BBAdminDashboard.settings-iframe.services', [])
angular.module('BBAdminDashboard.settings-iframe.directives', [])

angular.module('BBAdminDashboard.settings-iframe', [
  'BBAdminDashboard.settings-iframe.controllers',
  'BBAdminDashboard.settings-iframe.services',
  'BBAdminDashboard.settings-iframe.directives'
])
.run ['RuntimeStates', 'AdminSettingsIframeOptions', (RuntimeStates, AdminSettingsIframeOptions) ->
  # Choose to opt out of the default routing
  if AdminSettingsIframeOptions.use_default_states

    RuntimeStates
      .state 'settings',
        parent: AdminSettingsIframeOptions.parent_state
        url: "/settings"
        templateUrl: "admin_settings_page.html"
        deepStateRedirect: {
          default: { state: "settings.page", params: { path: "person" } }
          params: true
        }
        
      .state 'settings.page',
        url: "/page/:path"
        templateUrl: "iframe_page.html"
        controller: 'SettingsSubIframePageCtrl'  
]  