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
.run ['RuntimeStates', 'AdminLoginOptions', (RuntimeStates, AdminLoginOptions) ->
  # Choose to opt out of the default routing
  if AdminLoginOptions.use_default_states
    RuntimeStates
      .state 'login',
        url: "/login"
        resolve:
         user: ($q, BBModel, AdminSsoLogin) ->
          defer = $q.defer()
          BBModel.Admin.Login.$user().then (user) ->
            if user
              defer.resolve(user)
            else
              AdminSsoLogin.ssoLoginPromise().then (admin)->
                BBModel.Admin.Login.$setLogin admin
                BBModel.Admin.Login.$user().then (user) ->
                  defer.resolve(user)
                , (err) ->
                  defer.reject({reason: 'GET_USER_ERROR', error: err})
              , (err) ->
                defer.resolve()
          , (err) ->
            defer.reject({reason: 'LOGIN_SERVICE_ERROR', error: err})
          defer.promise
        controller: "LoginPageCtrl"
        templateUrl: "login/index.html"
]