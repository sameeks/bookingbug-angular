'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.reset-password.controller:ResetPasswordCtrl
#
* @description
* Controller for the reset password functionality
###

ResetPasswordCtrl = ($scope, $state, AdminLoginOptions, AdminLoginService, QueryStringService, ValidatorService, schemaForm, ResetPasswordService, ResetPasswordSchemaFormService) ->
  'ngInject'

  init = () ->

    if !$scope.base_url?
      $scope.base_url = $scope.reset_password_site

    $scope.template_vars =
      show_api_field: AdminLoginOptions.show_api_field
      reset_password_success: false
      show_loading: false

    if $scope.template_vars.show_api_field
      $scope.reset_password_site = angular.copy($scope.bb.api_url)

    $scope.validator = ValidatorService

    $scope.formErrors = []

    # decide which template to show
    if QueryStringService('reset_password_token')? and QueryStringService('reset_password_token') != 'undefined' and QueryStringService('reset_password_token') != ''
      $scope.reset_password_template = 'reset-password/reset-password-by-token.html'
      fetchSchemaForm()
    else
      $scope.reset_password_template = 'reset-password/reset-password.html'

    return

  # formErrors helper method
  formErrorExists = (message) ->
    # iterate through the formErrors array
    for obj in $scope.formErrors
      # check if the message passed in matches any pre-existing ones.
      if obj.message.match message
        return true
    return false

  # fetch Schema Form helper method
  fetchSchemaForm = () ->
    ResetPasswordSchemaFormService.getSchemaForm($scope.base_url).then (response) ->

      $scope.resetPasswordSchema = angular.copy(response.data.schema)

      ResetPasswordSchemaFormService.setPasswordPattern($scope.resetPasswordSchema.properties.password.pattern)
      $scope.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()
    , (err) ->
      ResetPasswordSchemaFormService.setPasswordPattern('^(?=[^\\s]*[^a-zA-Z])(?=[^\\s]*[a-zA-Z])[^\\s]{7,25}$')
      $scope.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()

    return

  $scope.goBackToLogin = () ->
    $state.go 'login'
    return

  $scope.sendResetPassword = (email, reset_password_site) ->
    $scope.template_vars.show_loading = true

    #if the site field is used, set the api url to the submmited url
    if $scope.template_vars.show_api_field and reset_password_site != ''
      $scope.reset_password_site = reset_password_site.replace(/\/+$/, '')
      if $scope.reset_password_site.indexOf("http") == -1
        $scope.reset_password_site = "https://" + $scope.reset_password_site
      $scope.base_url = $scope.reset_password_site

    ResetPasswordService.postRequest(email, $scope.base_url).then (response) ->
      $scope.template_vars.reset_password_success = true
      $scope.template_vars.show_loading = false
    , (err) ->
      $scope.template_vars.reset_password_success = false
      $scope.template_vars.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $scope.formErrors.push { message: message } if !formErrorExists message

    return

  $scope.submitSchemaForm = (password) ->
    $scope.template_vars.show_loading = true

    ResetPasswordSchemaFormService.postSchemaForm(password, $scope.base_url).then (response) ->
      $scope.template_vars.reset_password_success = true

      # password reset successful, so auto-login
      login_form = {"email": response.data.email, "password": password}

      AdminLoginService.login(login_form).then (response) ->
        $state.go 'login'
      , (err)->
        $scope.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}
        $scope.template_vars.show_loading = false

    , (err) ->
      $scope.template_vars.reset_password_success = false
      $scope.template_vars.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $scope.formErrors.push { message: message } if !formErrorExists message

    return

  init()

  return

angular
  .module('BBAdminDashboard.reset-password')
  .controller('ResetPasswordCtrl', ResetPasswordCtrl)
