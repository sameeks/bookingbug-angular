'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.reset-password.services.service:ResetPasswordService
*
* @description
* This service enables the user to send a request to reset he's password
*
###
angular.module('BBAdminDashboard.reset-password.services').factory 'ResetPasswordService', ($q, $window, $http) ->

  postRequest: (email, BaseURL) ->
    deferred = $q.defer()

    # Development Test url
    url = BaseURL + "/api/v1/login/admin/reset_password_email"
    # Production url
    # url = ""

    path = $window.location.pathname + '#/reset-password'

    body = {"email": email, "path": path}

    $http.post(url, body).then (response) =>
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise
