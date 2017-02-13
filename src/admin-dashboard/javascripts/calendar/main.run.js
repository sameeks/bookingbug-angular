// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.calendar').run(function(RuntimeStates, AdminCalendarOptions, SideNavigationPartials) {
  'ngInject';
  
  // Choose to opt out of the default routing
  if (AdminCalendarOptions.use_default_states) {

    RuntimeStates
    .state('calendar', {
      parent: AdminCalendarOptions.parent_state,
      url: "calendar",
      templateUrl: "calendar/index.html",
      controller: 'CalendarPageCtrl'
    }).state('calendar.people', {
      url: "/people/:assets",
      templateUrl: "calendar/people.html"
    }).state('calendar.resources', {
      url: "/resources/:assets",
      templateUrl: "calendar/resources.html"
    }
    );
  }

  if (AdminCalendarOptions.show_in_navigation) {
    SideNavigationPartials.addPartialTemplate('calendar', 'calendar/nav.html');
  }

});