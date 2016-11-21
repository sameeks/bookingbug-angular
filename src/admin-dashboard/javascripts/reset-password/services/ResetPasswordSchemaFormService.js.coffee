'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.reset-password.service:ResetPasswordSchemaFormService
*
* @description
* This service enables the user to fetch/submit a schema form from/to the server and also post the new password.
###

ResetPasswordSchemaFormService = ($q, $http, QueryStringService) ->
  'ngInject'

  passwordPattern = ''

  setPasswordPattern = (pattern) ->
    password_pattern = pattern

  getPasswordPattern = () ->
    return passwordPattern

  getSchemaForm = (baseUrl) ->
    deferred = $q.defer()
    src = baseUrl + "/api/v1/login/admin/reset_password_schema"

    $http.get(src, {}).then (response) ->
      deferred.resolve(response)
    , (err) ->
      deferred.reject(err)
    deferred.promise

  postSchemaForm = (password, baseUrl) ->
    deferred = $q.defer()
    src = baseUrl + "/api/v1/login/admin/reset_password"

    resetPasswordToken = QueryStringService('reset_password_token')

    body = {"password": password, "reset_password_token": resetPasswordToken}

    $http.put(src, body).then (response) ->
      deferred.resolve(response)
    , (err) ->
      deferred.reject(err)
    deferred.promise

  return {
    setPasswordPattern: setPasswordPattern
    getPasswordPattern: getPasswordPattern
    getSchemaForm: getSchemaForm
    postSchemaForm: postSchemaForm
  }

angular
  .module('BBAdminDashboard.reset-password')
  .factory('ResetPasswordSchemaFormService', ResetPasswordSchemaFormService)
