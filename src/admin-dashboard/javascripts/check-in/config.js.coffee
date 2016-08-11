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
.run ['RuntimeStates', 'AdminCheckInOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminCheckInOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminCheckInOptions.use_default_states

    RuntimeStates
      .state 'checkin',
        parent: AdminCheckInOptions.parent_state
        url: "check-in"
        templateUrl: 'check-in/index.html'
        controller: 'CheckInPageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.environment == 'development'
              script = 'bb-angular-admin-dashboard-check-in.lazy.js'
            else
              script = 'bb-angular-admin-dashboard-check-in.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }

  if AdminCheckInOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('check-in', 'core/nav/check-in.html')
]