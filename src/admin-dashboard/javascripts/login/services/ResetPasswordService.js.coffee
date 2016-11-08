'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.login.services.service:ResetPasswordService
*
* @description
* This service enables the user to send a request to reset he's password
*
###
angular.module('BBAdminDashboard.login.services').factory 'ResetPasswordService', ($q, ResetPasswordApiURL, $window, $http) ->

  postRequest: (email) ->
    deferred = $q.defer()

    # Development Test url
    url = ResetPasswordApiURL + "api/v1/login/admin/reset_password_email"
    # Production url
    # url = ""

    path = $window.location.pathname + '#/reset-password'

    body = {"email": email, "path": path}

    $http.post(url, body).then (response) =>
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise
