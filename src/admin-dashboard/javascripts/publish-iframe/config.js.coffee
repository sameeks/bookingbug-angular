'use strict'

angular.module('BBAdminDashboard.publish-iframe.controllers', [])
angular.module('BBAdminDashboard.publish-iframe.services', [])
angular.module('BBAdminDashboard.publish-iframe.directives', [])
angular.module('BBAdminDashboard.publish-iframe.translations', [])

angular.module('BBAdminDashboard.publish-iframe', [
  'BBAdminDashboard.publish-iframe.controllers',
  'BBAdminDashboard.publish-iframe.services',
  'BBAdminDashboard.publish-iframe.directives',
  'BBAdminDashboard.publish-iframe.translations'
])
.run ['RuntimeStates', 'AdminPublishIframeOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminPublishIframeOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminPublishIframeOptions.use_default_states

    RuntimeStates
      .state 'publish',
        parent: AdminPublishIframeOptions.parent_state
        url: 'publish'
        template: ()->
          $templateCache.get('publish-iframe/index.html')
        controller: 'PublishIframePageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.environment == 'development'
              script = 'bb-angular-admin-dashboard-publish-iframe.lazy.js'
            else
              script = 'bb-angular-admin-dashboard-publish-iframe.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }
        deepStateRedirect: {
          default: {
            state:  'publish.page'
            params: {
              path: 'conf/inset/intro'
            }
          }
        }

      .state 'publish.page',
        url: '/page/:path'
        template: ()->
          $templateCache.get('core/boxed-iframe-page.html')
        controller: 'PublishSubIframePageCtrl'

  if AdminPublishIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('publish-iframe', 'core/nav/publish-iframe.html')
]