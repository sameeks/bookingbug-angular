'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.reset-password.services.service:ResetPasswordSchemaFormService
*
* @description
* This service enables the user to fetch a schema form from the server.
*
###
angular.module('BBAdminDashboard.reset-password.services').factory 'ResetPasswordSchemaFormService', ($q, $rootScope, $http) ->

  # query: (email) ->
  #   deferred = $q.defer()
  #   # body = {"email": "admin2@bookingbug.com", "path": "path/to/reset/password/page"}
  #   # body = {"email": email, "path": "path/to/reset/password/page"}
  #   # Development Test url
  #   url = "http://7fb3e640.ngrok.io/api/v1/login/admin/reset_password_email"
  #   # Production url
  #   # url = ""

  getSchemaForm: () ->
    deferred = $q.defer()
    src = "http://7fb3e640.ngrok.io/api/v1/login/admin/reset_password_schema"
    $http.get(src, {}).then (response) ->
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise
