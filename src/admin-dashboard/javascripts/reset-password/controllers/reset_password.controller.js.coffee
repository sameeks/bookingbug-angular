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

    if !$scope.base_url?
      $scope.base_url = $resetPasswordCtrl.reset_password_site

    $resetPasswordCtrl.show_api_field = AdminLoginOptions.show_api_field
    $resetPasswordCtrl.reset_password_success = false
    $resetPasswordCtrl.show_loading = false

    if $resetPasswordCtrl.show_api_field
      $resetPasswordCtrl.reset_password_site = angular.copy($scope.bb.api_url)

    $resetPasswordCtrl.validator = ValidatorService

    $resetPasswordCtrl.formErrors = []

    # decide which template to show
    if QueryStringService('reset_password_token')? and QueryStringService('reset_password_token') != 'undefined' and QueryStringService('reset_password_token') != ''
      $resetPasswordCtrl.reset_password_template = 'reset-password/reset-password-by-token.html'
      fetchSchemaForm()
    else
      $resetPasswordCtrl.reset_password_template = 'reset-password/reset-password.html'

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
    ResetPasswordSchemaFormService.getSchemaForm($scope.base_url).then (response) ->

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

  $resetPasswordCtrl.sendResetPassword = (email, reset_password_site) ->
    $resetPasswordCtrl.show_loading = true

    #if the site field is used, set the api url to the submmited url
    if $resetPasswordCtrl.show_api_field and reset_password_site != ''
      $resetPasswordCtrl.reset_password_site = reset_password_site.replace(/\/+$/, '')
      if $resetPasswordCtrl.reset_password_site.indexOf("http") == -1
        $resetPasswordCtrl.reset_password_site = "https://" + $resetPasswordCtrl.reset_password_site
      $scope.base_url = $resetPasswordCtrl.reset_password_site

    ResetPasswordService.postRequest(email, $scope.base_url).then (response) ->
      $resetPasswordCtrl.reset_password_success = true
      $resetPasswordCtrl.show_loading = false
    , (err) ->
      $resetPasswordCtrl.reset_password_success = false
      $resetPasswordCtrl.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $resetPasswordCtrl.formErrors.push { message: message } if !formErrorExists message

    return

  $resetPasswordCtrl.submitSchemaForm = (password) ->
    $resetPasswordCtrl.show_loading = true

    ResetPasswordSchemaFormService.postSchemaForm(password, $scope.base_url).then (response) ->
      $resetPasswordCtrl.reset_password_success = true

      # password reset successful, so auto-login
      login_form = {"email": response.data.email, "password": password}

      AdminLoginService.login(login_form).then (response) ->
        $state.go 'login'
      , (err)->
        $resetPasswordCtrl.show_loading = false
        $resetPasswordCtrl.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}

    , (err) ->
      $resetPasswordCtrl.reset_password_success = false
      $resetPasswordCtrl.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $resetPasswordCtrl.formErrors.push { message: message } if !formErrorExists message

    return

  init()

  return

angular
  .module('BBAdminDashboard.reset-password')
  .controller('ResetPasswordCtrl', ResetPasswordCtrl)
