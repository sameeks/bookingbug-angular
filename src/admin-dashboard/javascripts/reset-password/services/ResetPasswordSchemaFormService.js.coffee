'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.reset-password.services.service:ResetPasswordSchemaFormService
*
* @description
* This service enables the user to fetch/submit a schema form from/to the server and also post the new password.
*
###
angular.module('BBAdminDashboard.reset-password.services').factory 'ResetPasswordSchemaFormService', ($q, QueryStringService, $http) ->

  password_pattern = ''

  setPasswordPattern: (pattern) ->
    password_pattern = pattern

  getPasswordPattern: () ->
    return password_pattern

  getSchemaForm: (base_url) ->
    deferred = $q.defer()
    src = base_url + "/api/v1/login/admin/reset_password_schema"

    $http.get(src, {}).then (response) ->
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  postSchemaForm: (password, base_url) ->
    deferred = $q.defer()
    src = base_url + "/api/v1/login/admin/reset_password"

    reset_password_token = QueryStringService('reset_password_token')

    body = {"password": password, "reset_password_token": reset_password_token}

    $http.put(src, body).then (response) ->
      deferred.resolve(response)
    , (err) =>
      deferred.reject(err)
    deferred.promise
