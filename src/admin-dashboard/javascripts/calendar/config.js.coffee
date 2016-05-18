'use strict'

angular.module('BBAdminDashboard.calendar.controllers', [])
angular.module('BBAdminDashboard.calendar.services', [])
angular.module('BBAdminDashboard.calendar.directives', [])

angular.module('BBAdminDashboard.calendar', [
  'BBAdminDashboard.calendar.controllers',
  'BBAdminDashboard.calendar.services',
  'BBAdminDashboard.calendar.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'calendar',
      parent: 'root'
      url: "/calendar/:assets"
      templateUrl: "calendar_page.html"
      controller: 'CalendarPageCtrl'
]