'use strict'

angular.module('BBAdminDashboard.calendar.controllers', [])
angular.module('BBAdminDashboard.calendar.services', [])
angular.module('BBAdminDashboard.calendar.directives', [])
angular.module('BBAdminDashboard.calendar.translations', [])

angular.module('BBAdminDashboard.calendar', [
  'BBAdminDashboard.calendar.controllers',
  'BBAdminDashboard.calendar.services',
  'BBAdminDashboard.calendar.directives',
  'BBAdminDashboard.calendar.translations'
])
.run ['RuntimeStates', 'AdminCalendarOptions', 'SideNavigationPartials', '$templateCache', (RuntimeStates, AdminCalendarOptions, SideNavigationPartials, $templateCache) ->
  # Choose to opt out of the default routing
  if AdminCalendarOptions.use_default_states

    RuntimeStates
      .state 'calendar',
        parent: AdminCalendarOptions.parent_state
        url: "calendar/:assets"
        templateUrl: 'calendar/index.html'
        controller: 'CalendarPageCtrl'
        resolve: {
          loadModule: ['$ocLazyLoad', '$rootScope', ($ocLazyLoad, $rootScope) ->
            if $rootScope.minified == false
              script = 'bookingbug-angular-admin-dashboard-calendar.lazy.js'
            else
              script = 'bookingbug-angular-admin-dashboard-calendar.lazy.min.js'
            $ocLazyLoad.load(script);
          ]
        }

  if AdminCalendarOptions.show_in_navigation
    SideNavigationPartials.addPartialTemplate('calendar', 'core/nav/calendar.html')
]