'use strict'
angular.module('BBAdminDashboard.calendar').run (RuntimeStates, AdminCalendarOptions, SideNavigationPartials) ->
  'ngInject'
  
  # Choose to opt out of the default routing
  if AdminCalendarOptions.useDefaultStates

    RuntimeStates
    .state 'calendar',
      parent: AdminCalendarOptions.parentState
      url: "calendar"
      templateUrl: "calendar/index.html"
      controller: 'CalendarPageCtrl'
    .state 'calendar.people',
      url: "/people/:assets"
      templateUrl: "calendar/people.html"
    .state 'calendar.resources',
      url: "/resources/:assets"
      templateUrl: "calendar/resources.html"

  if AdminCalendarOptions.showInNavigation
    SideNavigationPartials.addPartialTemplate('calendar', 'calendar/nav.html')

  return