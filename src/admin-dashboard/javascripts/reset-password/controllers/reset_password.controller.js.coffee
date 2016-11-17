'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.reset-password.controller:ResetPasswordCtrl
#
* @description
* Controller for the reset password functionality
###

ResetPasswordCtrl = ($scope, $state, AdminLoginOptions, AdminLoginService, QueryStringService, ValidatorService, ResetPasswordService, ResetPasswordSchemaFormService) ->
  'ngInject'

  $resetPasswordCtrl = @

  init = () ->

    if !$scope.baseUrl?
      $scope.baseUrl = $resetPasswordCtrl.resetPasswordSite

    $resetPasswordCtrl.showApiField = AdminLoginOptions.show_api_field
    $resetPasswordCtrl.resetPasswordSuccess = false
    $resetPasswordCtrl.showLoading = false

    if $resetPasswordCtrl.showApiField
      $resetPasswordCtrl.resetPasswordSite = angular.copy($scope.bb.api_url)

    $resetPasswordCtrl.validator = ValidatorService

    $resetPasswordCtrl.formErrors = []

    # decide which template to show
    if QueryStringService('reset_password_token')? and QueryStringService('reset_password_token') != 'undefined' and QueryStringService('reset_password_token') != ''
      $resetPasswordCtrl.resetPasswordTemplate = 'reset-password/reset-password-by-token.html'
      fetchSchemaForm()
    else
      $resetPasswordCtrl.resetPasswordTemplate = 'reset-password/reset-password.html'

    return

  # formErrors helper method
  formErrorExists = (message) ->
    # iterate through the formErrors array
    for obj in $resetPasswordCtrl.formErrors
      # check if the message passed in matches any pre-existing ones.
      if obj.message.match message
        return true
    return false

  # fetch Schema Form helper method
  fetchSchemaForm = () ->
    ResetPasswordSchemaFormService.getSchemaForm($scope.baseUrl).then (response) ->

      $resetPasswordCtrl.resetPasswordSchema = angular.copy(response.data.schema)

      ResetPasswordSchemaFormService.setPasswordPattern($resetPasswordCtrl.resetPasswordSchema.properties.password.pattern)
      $resetPasswordCtrl.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()
    , (err) ->
      ResetPasswordSchemaFormService.setPasswordPattern('^(?=[^\\s]*[^a-zA-Z])(?=[^\\s]*[a-zA-Z])[^\\s]{7,25}$')
      $resetPasswordCtrl.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()

    return

  $resetPasswordCtrl.goBackToLogin = () ->
    $state.go 'login'
    return

  $resetPasswordCtrl.sendResetPassword = (email, resetPasswordSite) ->
    $resetPasswordCtrl.showLoading = true

    #if the site field is used, set the api url to the submmited url
    if $resetPasswordCtrl.showApiField and resetPasswordSite != ''
      # strip trailing spaces from the url to avoid calling an invalid endpoint
      # since all service calls to api end-points begin with '/', e.g '/api/v1/...'
      $resetPasswordCtrl.resetPasswordSite = resetPasswordSite.replace(/\/+$/, '')
      if $resetPasswordCtrl.resetPasswordSite.indexOf("http") == -1
        $resetPasswordCtrl.resetPasswordSite = "https://" + $resetPasswordCtrl.resetPasswordSite
      $scope.baseUrl = $resetPasswordCtrl.resetPasswordSite

    ResetPasswordService.postRequest(email, $scope.baseUrl).then (response) ->
      $resetPasswordCtrl.resetPasswordSuccess = true
      $resetPasswordCtrl.showLoading = false
    , (err) ->
      $resetPasswordCtrl.resetPasswordSuccess = false
      $resetPasswordCtrl.showLoading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $resetPasswordCtrl.formErrors.push { message: message } if !formErrorExists message

    return

  $resetPasswordCtrl.submitSchemaForm = (password) ->
    $resetPasswordCtrl.showLoading = true

    ResetPasswordSchemaFormService.postSchemaForm(password, $scope.baseUrl).then (response) ->
      $resetPasswordCtrl.resetPasswordSuccess = true

      # password reset successful, so auto-login
      loginForm = {"email": response.data.email, "password": password}

      AdminLoginService.login(loginForm).then (response) ->
        $state.go 'login'
      , (err)->
        $resetPasswordCtrl.showLoading = false
        $resetPasswordCtrl.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}

    , (err) ->
      $resetPasswordCtrl.resetPasswordSuccess = false
      $resetPasswordCtrl.showLoading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $resetPasswordCtrl.formErrors.push { message: message } if !formErrorExists message

    return

  init()

  return

angular
  .module('BBAdminDashboard.reset-password')
  .controller('ResetPasswordCtrl', ResetPasswordCtrl)
