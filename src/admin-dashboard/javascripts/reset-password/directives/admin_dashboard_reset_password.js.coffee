'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.reset-password.directives.directive:adminDashboardResetPassword
 * @scope
 * @restrict A
 *
 * @description
 * Admin Dashboard ResetPassword journey directive
 *
 * @param {object} field   A field object
###

angular.module('BBAdminDashboard.reset-password.directives').directive 'adminDashboardResetPassword', () ->
  restrict: 'AE'
  replace: true
  scope : true
  template: '<div ng-include="reset_password_template"></div>'
  controller : 'ResetPassword'
  link : (scope, element, attrs) ->
    return

angular.module('BBAdminDashboard.reset-password.controllers')
.controller 'ResetPassword', ($scope, $state, AdminLoginOptions, AdminLoginService, QueryStringService, ValidatorService, schemaForm, ResetPasswordService, ResetPasswordSchemaFormService) ->
  'ngInject'

  init = () ->

    $scope.template_vars =
      show_api_field: AdminLoginOptions.show_api_field
      show_reset_password: true
      show_reset_password_success: false
      show_reset_password_fail: false
      show_loading: false

    $scope.validator = ValidatorService

    $scope.formErrors = []

    $scope.reset_password_site = angular.copy($scope.bb.api_url)

    if $scope.bb.api_url? and $scope.bb.api_url != ''
      $scope.BaseURL = angular.copy($scope.bb.api_url)
    else if $scope.reset_password_site? and $scope.reset_password_site != ''
      $scope.BaseURL = angular.copy($scope.reset_password_site)
    else
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.ERROR_API_MISSING"
      $scope.formErrors.push { message: message } if !formErrorExists message
      # temporary local test url
      $scope.BaseURL = "http://526e0d94.ngrok.io"
      $scope.reset_password_site = angular.copy($scope.BaseURL)

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
    ResetPasswordSchemaFormService.getSchemaForm($scope.BaseURL).then (response) ->

      # angular schema Form
      # $scope.resetPasswordSchema = angular.copy(response.data.schema)
      # $scope.resetPasswordForm = angular.copy(response.data.form)
      # $scope.resetPasswordModel = {}

      $scope.resetPasswordSchema = angular.copy(response.data.schema)

      ResetPasswordSchemaFormService.setPasswordPattern($scope.resetPasswordSchema.properties.password.pattern)
      $scope.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()
    , (err) ->
      console.log "Error: ", err
      ResetPasswordSchemaFormService.setPasswordPattern('^(?=[^\s]*[^a-zA-Z])(?=[^\s]*[a-zA-Z])[^\s]{7,25}$')
      $scope.reset_password_pattern = ResetPasswordSchemaFormService.getPasswordPattern()

    return

  $scope.goBackToLogin = () ->
    $state.go 'login'
    return

  $scope.sendResetPassword = (email) ->
    $scope.template_vars.show_loading = true

    ResetPasswordService.postRequest(email, $scope.BaseURL).then (response) ->
      $scope.template_vars.show_reset_password = false
      $scope.template_vars.show_reset_password_success = true
      $scope.template_vars.show_loading = false
    , (err) ->
      console.log "Error: ", err
      $scope.template_vars.show_reset_password_fail = true
      $scope.template_vars.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $scope.formErrors.push { message: message } if !formErrorExists message

    return

  $scope.submitSchemaForm = (password) ->
    $scope.template_vars.show_loading = true

    ResetPasswordSchemaFormService.postSchemaForm(password, $scope.BaseURL).then (response) ->
      $scope.template_vars.show_reset_password = false
      $scope.template_vars.show_reset_password_success = true
      $scope.template_vars.show_loading = false

      # password reset successful, so auto-login next
      login_form = {"email": response.data.email, "password": password}

      AdminLoginService.login(login_form).then (response) ->
        $state.go 'login'
      , (err)->
        $scope.formErrors.push { message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"}

    , (err) ->
      console.log "Error: ", err
      $scope.template_vars.show_reset_password_fail = true
      $scope.template_vars.show_loading = false
      message = "ADMIN_DASHBOARD.RESET_PASSWORD_PAGE.FORM_SUBMIT_FAIL_MSG"
      $scope.formErrors.push { message: message } if !formErrorExists message

    return

  init()

  return
