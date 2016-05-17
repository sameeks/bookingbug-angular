'use strict'

angular.module('BBAdminDashboard.login.controllers', [])
angular.module('BBAdminDashboard.login.services', [])
angular.module('BBAdminDashboard.login.directives', [])

angular.module('BBAdminDashboard.login', [
  'BBAdminDashboard.login.controllers',
  'BBAdminDashboard.login.services',
  'BBAdminDashboard.login.directives'
])
.config ['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state 'login',
      url: "/login"
      controller: "LoginPageCtrl"
      templateUrl: "admin_login_page.html"
]