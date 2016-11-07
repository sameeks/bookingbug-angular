'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.login.services.service:ResetPasswordService
*
* @description
* This service enables the user to send a request to reset he's password
*
###
angular.module('BBAdminDashboard.login.services').factory 'ResetPasswordService', ($q, $rootScope, $http) ->

  query: (body) ->
    deferred = $q.defer()
    body = {"email": "admin2@bookingbug.com", "path": "path/to/reset/password/page"}
    # Development Test url
    url = "http://7fb3e640.ngrok.io/api/v1/login/admin/reset_password_email"
    # Production url
    # url = ""

    $http.post(url, body).then (response) =>
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise
