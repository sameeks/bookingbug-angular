'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.logout.controllers.controller:resetPasswordPageCtrl
#
* @description
* Controller for the logout page
###
angular.module('BBAdminDashboard.reset-password.controllers')
.controller 'resetPasswordPageCtrl', ['$scope', '$state', 'schemaForm', 'ResetPasswordSchemaFormService', ($scope, $state, schemaForm, ResetPasswordSchemaFormService) ->
  # BBModel.Admin.Login.$logout().then ()->
  #   $sessionStorage.removeItem("user")
  #   $sessionStorage.removeItem("auth_token")

  #   AdminSsoLogin.ssoToken = null
  #   AdminSsoLogin.companyId = null

  #   $state.go 'login', {}, {reload: true}

  #   return


# ---------------------------------------
  # working example of Schema Form
# ---------------------------------------

  # $scope.resetPasswordSchema = {
  #   type: "object",
  #   title: "Reset Password",
  #   properties: {
  #     password: {
  #       title: "New password",
  #       type: "password",
  #       pattern: "^\\S+@\\S+$",
  #       validationMessage: "must include letters and numbers."
  #     },
  #     password_confirmation: {
  #       title: "Confirm new password",
  #       type: "string",
  #       pattern: "(?-mix:(?=.*[^a-zA-Z])(?=.*[a-zA-Z])(?=^[[:graph:]]+$).{7,})"
  #     }
  #   },
  #   "required": null
  # }

  # $scope.resetPasswordForm = [
  #   "password",
  #   "password_confirmation",
  #   {
  #     "key": "comment",
  #     "type": "textarea",
  #     "placeholder": "Make a comment"
  #   },
  #   {
  #     "type": "submit",
  #     "style": "btn-info",
  #     "title": "OK"
  #   }
  # ]

  # $scope.resetPasswordModel = {}

# ---------------------------------------
  # /end working example of Schema Form
# ---------------------------------------


  # temporary local test url
  BaseURL = "http://7fb3e640.ngrok.io/"
  # BaseURL = "#{$scope.bb.api_url}"

  ResetPasswordSchemaFormService.getSchemaForm(BaseURL).then (response) ->
    console.log "response.data.schema :", response.data.schema
    console.log "response.data.form :", response.data.form

    $scope.resetPasswordSchema = angular.copy(response.data.schema)

    $scope.resetPasswordForm = angular.copy(response.data.form)

    console.log "scope form: ", $scope.resetPasswordForm
    console.log "scope schema: ", $scope.resetPasswordSchema

    $scope.resetPasswordModel = {}
  , (err) ->
    console.log "Error: ", err

  $scope.submitSchemaForm = (form, BaseURL) ->
    console.log form
    # First we broadcast an event so all fields validate themselves
    $scope.$broadcast('schemaFormValidate')

    # Then we check if the form is valid
    if form.$valid
      console.log "form is valid"

    ResetPasswordSchemaFormService.postSchemaForm(model.password).then (response) ->
      console.log "response from POST :", response
    , (err) ->
      console.log "Error: ", err

  return
]
