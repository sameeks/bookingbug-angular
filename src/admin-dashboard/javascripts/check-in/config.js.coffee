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
.run ['RuntimeStates', 'AdminCheckInOptions', (RuntimeStates, AdminCheckInOptions) ->
  # Choose to opt out of the default routing
  if AdminCheckInOptions.use_default_states

    RuntimeStates
      .state 'checkin',
        parent: AdminCheckInOptions.parent_state
        url: "/check-in"
        templateUrl: "checkin_page.html"
        controller: 'CheckInPageCtrl'
]  