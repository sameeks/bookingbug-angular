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
.run ['RuntimeStates', 'AdminCalendarOptions', 'SideNavigationPartials', (RuntimeStates, AdminCalendarOptions, SideNavigationPartials) ->
  # Choose to opt out of the default routing
  if AdminCalendarOptions.use_default_states

    RuntimeStates
      .state 'calendar',
        parent: AdminCalendarOptions.parent_state
        url: "/calendar/:assets"
        templateUrl: "calendar_page.html"
        controller: 'CalendarPageCtrl'

  if AdminCalendarOptions.show_in_navigation 
    SideNavigationPartials.addPartialTemplate('calendar', 'calendar/nav.html')    
]    