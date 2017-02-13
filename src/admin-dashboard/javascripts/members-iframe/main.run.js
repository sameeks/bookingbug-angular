'use strict'

angular.module('BBAdminDashboard.members-iframe').run (RuntimeStates, AdminMembersIframeOptions, SideNavigationPartials) ->
  'ngInject'

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
          state: 'members.page'
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

  return