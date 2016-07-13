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
.run (RuntimeStates, AdminMembersIframeOptions) ->
  # Choose to opt out of the default routing
  if AdminMembersIframeOptions.use_default_states

    RuntimeStates
      .state 'members',
        parent: AdminMembersIframeOptions.parent_state
        url: '/members'
        templateUrl: 'admin_members_page.html'
        controller: 'MembersIframePageCtrl'

      .state 'members.page',
        url: '/page/:path/:id'
        templateUrl: 'iframe_page.html'
        controller: 'MembersSubIframePageCtrl'

