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
.run ['RuntimeStates', 'AdminConfigIframeOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminConfigIframeOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminConfigIframeOptions.use_default_states

    RuntimeStates
      .state 'config',
        parent: AdminConfigIframeOptions.parent_state
        url: 'config'
        template: ()->
          $templateCache.get('config-iframe/index.html')
        controller: 'ConfigIframePageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.minified == false
              script = 'bookingbug-angular-admin-dashboard-config-iframe.lazy.js'
            else
              script = 'bookingbug-angular-admin-dashboard-config-iframe.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }
        deepStateRedirect: {
          default: {
            state: 'config.business.page'
            params: {
              path: 'person'
            }
          }
        }

      .state 'config.business',
        url: '/business'
        template: ()->
          $templateCache.get('core/tabbed-substates-page.html')
        controller: 'ConfigIframeBusinessPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'config.business.page'
            params: {
              path: 'person'
            }
          }
        }
      .state 'config.business.page',
        url: '/page/:path'
        template: ()->
          $templateCache.get('core/iframe-page.html')
        controller: 'ConfigSubIframePageCtrl'

      .state 'config.event-settings',
        url: '/event-settings'
        template: ()->
          $templateCache.get('core/tabbed-substates-page.html')
        controller: 'ConfigIframeEventSettingsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'config.event-settings.page'
            params: {
              path: 'sessions/courses'
            }
          }
        }
      .state 'config.event-settings.page',
        url: '/page/:path'
        template: ()->
          $templateCache.get('core/iframe-page.html')
        controller: 'ConfigSubIframePageCtrl'

      .state 'config.promotions',
        url: '/promotions'
        template: ()->
          $templateCache.get('core/tabbed-substates-page.html')
        controller: 'ConfigIframePromotionsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'config.promotions.page'
            params: {
              path: 'price/deal/summary'
            }
          }
        }
      .state 'config.promotions.page',
        url: '/page/:path'
        template: ()->
          $templateCache.get('core/iframe-page.html')
        controller: 'ConfigSubIframePageCtrl'

      .state 'config.booking-settings',
        url: '/booking-settings'
        template: ()->
          $templateCache.get('core/tabbed-substates-page.html')
        controller: 'ConfigIframeBookingSettingsPageCtrl'
        deepStateRedirect: {
          default: {
            state: 'config.booking-settings.page'
            params: {
              path: 'detail_type'
            }
          }
        }
      .state 'config.booking-settings.page',
        url: '/page/:path'
        template: ()->
          $templateCache.get('core/iframe-page.html')
        controller: 'ConfigSubIframePageCtrl'

  if AdminConfigIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('config-iframe', 'core/nav/config-iframe.html')
]