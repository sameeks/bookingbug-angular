'use strict'

angular.module('BBAdminDashboard.settings-iframe.controllers', [])
angular.module('BBAdminDashboard.settings-iframe.services', [])
angular.module('BBAdminDashboard.settings-iframe.directives', [])
angular.module('BBAdminDashboard.settings-iframe.translations', [])

angular.module('BBAdminDashboard.settings-iframe', [
  'BBAdminDashboard.settings-iframe.controllers',
  'BBAdminDashboard.settings-iframe.services',
  'BBAdminDashboard.settings-iframe.directives',
  'BBAdminDashboard.settings-iframe.translations',
])
.run ['RuntimeStates', 'AdminSettingsIframeOptions', 'SideNavigationPartials', (RuntimeStates, AdminSettingsIframeOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminSettingsIframeOptions.use_default_states

    RuntimeStates
      .state 'settings',
        parent: AdminSettingsIframeOptions.parent_state
        url: "/settings"
        templateUrl: "settings-iframe/index.html"
        deepStateRedirect: {
          default: { state: "settings.page", params: { path: "company/mycompany" } }
          params: true
        }

      .state 'settings.page',
        url: "/page/:path"
        templateUrl: "core/boxed-iframe-page.html"
        controller: 'SettingsSubIframePageCtrl'

      .state 'settings.basic-settings',
        url: '/basic-settings'
        templateUrl: 'core/tabbed-substates-page.html'
        controller: 'SettingsIframeBasicSettingsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'settings.basic-settings.page'
            params: {
              path: 'conf/setting/user_edit'
            }
          }
        }
      .state 'settings.basic-settings.page',
        url: '/page/:path'
        templateUrl: 'core/iframe-page.html'
        controller: 'SettingsSubIframePageCtrl'

      .state 'settings.advanced-settings',
        url: '/advanced-settings'
        templateUrl: 'core/tabbed-substates-page.html'
        controller: 'SettingsIframeAdvancedSettingsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'settings.advanced-settings.page'
            params: {
              path: 'conf/payment/payment_edit'
            }
          }
        }
      .state 'settings.advanced-settings.page',
        url: '/page/:path'
        templateUrl: 'core/iframe-page.html'
        controller: 'SettingsSubIframePageCtrl'

      .state 'settings.integrations',
        url: '/integrations'
        templateUrl: 'core/tabbed-substates-page.html'
        controller: 'SettingsIframeIntegrationsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'settings.integrations.page'
            params: {
              path: 'conf/addons/payment'
            }
          }
        }
      .state 'settings.integrations.page',
        url: '/page/:path'
        templateUrl: 'core/iframe-page.html'
        controller: 'SettingsSubIframePageCtrl'

      .state 'settings.subscription',
        url: '/subscription'
        templateUrl: 'core/tabbed-substates-page.html'
        controller: 'SettingsIframeSubscriptionPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'settings.subscription.page'
            params: {
              path: 'subscription/show'
            }
          }
        }
      .state 'settings.subscription.page',
        url: '/page/:path'
        templateUrl: 'core/iframe-page.html'
        controller: 'SettingsSubIframePageCtrl'


  if AdminSettingsIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('settings-iframe', 'settings-iframe/nav.html')
]