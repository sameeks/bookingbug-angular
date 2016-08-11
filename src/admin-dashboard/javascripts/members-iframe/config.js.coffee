'use strict'

angular.module('BBAdminDashboard.members-iframe.controllers', [])
angular.module('BBAdminDashboard.members-iframe.services', [])
angular.module('BBAdminDashboard.members-iframe.directives', [])
angular.module('BBAdminDashboard.members-iframe.translations', [])

angular.module('BBAdminDashboard.members-iframe', [
  'BBAdminDashboard.members-iframe.controllers',
  'BBAdminDashboard.members-iframe.services',
  'BBAdminDashboard.members-iframe.directives',
  'BBAdminDashboard.members-iframe.translations'
])
.run ['RuntimeStates', 'AdminMembersIframeOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminMembersIframeOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminMembersIframeOptions.use_default_states

    RuntimeStates
      .state 'members',
        parent: AdminMembersIframeOptions.parent_state
        url: 'members'
        template: ()->
          $templateCache.get('members-iframe/index.html')
        controller: 'MembersIframePageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.environment == 'development'
              script = 'bb-angular-admin-dashboard-members-iframe.lazy.js'
            else
              script = 'bb-angular-admin-dashboard-members-iframe.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }
        deepStateRedirect: {
          default: {
            state:  'members.page'
            params: {
              path: 'client'
            }
          }
        }

      .state 'members.page',
        url: '/page/:path/:id'
        template: ()->
          $templateCache.get('core/boxed-iframe-page.html')
        controller: 'MembersSubIframePageCtrl'

  if AdminMembersIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('members-iframe', 'core/nav/members-iframe.html')
]