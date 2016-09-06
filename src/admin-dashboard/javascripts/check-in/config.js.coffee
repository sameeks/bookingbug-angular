'use strict'

angular.module('BBAdminDashboard.check-in.controllers', [])
angular.module('BBAdminDashboard.check-in.services', [])
angular.module('BBAdminDashboard.check-in.directives', [])
angular.module('BBAdminDashboard.check-in.translations', [])

angular.module('BBAdminDashboard.check-in', [
  'BBAdminDashboard.check-in.controllers',
  'BBAdminDashboard.check-in.services',
  'BBAdminDashboard.check-in.directives',
  'BBAdminDashboard.check-in.translations'
])
.run ['RuntimeStates', 'AdminCheckInOptions', 'SideNavigationPartials', (RuntimeStates, AdminCheckInOptions, SideNavigationPartials) ->
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
]