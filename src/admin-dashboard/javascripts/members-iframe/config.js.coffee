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
.run ['RuntimeStates', 'AdminMembersIframeOptions', 'SideNavigationPartials', (RuntimeStates, AdminMembersIframeOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminMembersIframeOptions.use_default_states

    RuntimeStates
      .state 'members',
        parent: AdminMembersIframeOptions.parent_state
        url: 'members'
        templateUrl: 'members-iframe/index.html'
        controller: 'MembersIframePageCtrl'
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
        templateUrl: 'core/boxed-iframe-page.html'
        controller: 'MembersSubIframePageCtrl'

  if AdminMembersIframeOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('members-iframe', 'members-iframe/nav.html')
]