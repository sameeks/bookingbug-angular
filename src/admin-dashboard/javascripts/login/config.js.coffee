'use strict'

angular.module('BBAdminDashboard.login.controllers', [])
angular.module('BBAdminDashboard.login.services', [])
angular.module('BBAdminDashboard.login.directives', [])
angular.module('BBAdminDashboard.login.translations', [])

angular.module('BBAdminDashboard.login', [
  'BBAdminDashboard.login.controllers',
  'BBAdminDashboard.login.services',
  'BBAdminDashboard.login.directives',
  'BBAdminDashboard.login.translations'
])
.run (RuntimeStates, AdminLoginOptions) ->
  # Choose to opt out of the default routing
  if AdminLoginOptions.use_default_states
    RuntimeStates
      .state 'login',
        url: "/login"
        controller: "LoginPageCtrl"
        templateUrl: "admin_login_page.html"

