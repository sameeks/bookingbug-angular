'use strict'

angular.module('BBAdminDashboard.check-in.controllers', [])
angular.module('BBAdminDashboard.check-in.services', [])
angular.module('BBAdminDashboard.check-in.directives', [])

angular.module('BBAdminDashboard.check-in', [
  'BBAdminDashboard.check-in.controllers',
  'BBAdminDashboard.check-in.services',
  'BBAdminDashboard.check-in.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider.state 'checkin',
    parent: 'root'
    url: "/check-in"
    templateUrl: "checkin_page.html"
    controller: 'CheckInPageCtrl'
]