'use strict'

angular.module('BBAdminDashboard.logout.controllers', [])
angular.module('BBAdminDashboard.logout.services', [])
angular.module('BBAdminDashboard.logout.directives', [])

angular.module('BBAdminDashboard.logout', [
  'BBAdminDashboard.logout.controllers',
  'BBAdminDashboard.logout.services',
  'BBAdminDashboard.logout.directives'
])
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'logout',
      url: '/logout'
      controller: 'LogoutPageCtrl'

