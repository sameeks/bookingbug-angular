'use strict'

angular.module('BBAdminDashboard.check-in').run (RuntimeStates, AdminCheckInOptions, SideNavigationPartials) ->
  'ngInject'

  # Choose to opt out of the default routing
  if AdminCheckInOptions.use_default_states

    RuntimeStates
    .state 'checkin',
      parent: AdminCheckInOptions.parent_state
      url: "check-in"
      templateUrl: "check-in/index.html"
      controller: 'CheckInPageCtrl'

  if AdminCheckInOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('check-in', 'check-in/nav.html')

  return