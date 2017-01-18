'use strict'

angular.module('BB.Controllers').controller 'Login', ($scope, $rootScope, $q, $location, LoginService, ValidatorService, AlertService, LoadingService, BBModel) ->

  $scope.validator = ValidatorService
  $scope.login_form = {}

  loader = LoadingService.$loader($scope)

  ###**
  * @ngdoc method
  * @name login_sso
  * @methodOf BB.Directives:bbLogin
  * @description
  * Login to application
  *
  * @param {object} token The token to use for login
  * @param {string=} route A specific route to load
  ###
  $scope.login_sso = (token, route) ->
    $rootScope.connection_started.then =>
      LoginService.ssoLogin({company_id: $scope.bb.company.id, root: $scope.bb.api_url}, {token: token}).then (member) =>
        $scope.showPage(route) if route
      , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
    , (err) -> loader.setLoadedAndShowError(err, 'Sorry, something went wrong')

  ###**
  * @ngdoc method
  * @name login_with_password
  * @methodOf BB.Directives:bbLogin
  * @description
  * Login with password
  *
  * @param {string} email The email address that use for the login
  * @param {string} password The password use for the login
  ###
  $scope.login_with_password = (email, password) ->
    LoginService.companyLogin($scope.bb.company, {}, {email: email, password: password}).then (member) =>
      $scope.member = new BBModel.Member.Member(member)
    , (err) =>
      AlertService.raise('LOGIN_FAILED')

  ###**
  * @ngdoc method
  * @name showEmailPasswordReset
  * @methodOf BB.Directives:bbLogin
  * @description
  * Display email reset password page
  ###
  $scope.showEmailPasswordReset = () =>
    $scope.showPage('email_reset_password')

  ###**
  * @ngdoc method
  * @name isLoggedIn
  * @methodOf BB.Directives:bbLogin
  * @description
  * Verify if user are logged in
  ###
  $scope.isLoggedIn = () ->
    LoginService.isLoggedIn()

  ###**
  * @ngdoc method
  * @name sendPasswordReset
  * @methodOf BB.Directives:bbLogin
  * @description
  * Send password reset via email
  *
  * @param {string} email The email address use for the send new password
  ###
  $scope.sendPasswordReset = (email) ->
    LoginService.sendPasswordReset($scope.bb.company, {email: email, custom: true}).then () ->
      AlertService.raise('PASSWORD_RESET_REQ_SUCCESS')
    , (err) =>
      AlertService.raise('PASSWORD_RESET_REQ_FAILED')

  ###**
  * @ngdoc method
  * @name updatePassword
  * @methodOf BB.Directives:bbLogin
  * @description
  * Update password
  *
  * @param {string} new_password The new password has been set
  * @param {string} confirm_new_password The new password has been confirmed
  ###
  $scope.updatePassword = (new_password, confirm_new_password) ->
    AlertService.clear()
    if $rootScope.member and new_password and confirm_new_password and (new_password is confirm_new_password)
      LoginService.updatePassword($rootScope.member, {new_password: new_password, confirm_new_password: confirm_new_password, persist_login: $scope.login_form.persist_login}).then (member) =>
        if member
          $scope.setClient(member)
          $scope.password_updated = true
          AlertService.raise('PASSWORD_RESET_SUCESS')
      , (err) =>
        $scope.error = err
        AlertService.raise('PASSWORD_RESET_FAILED')
    else
      AlertService.raise('PASSWORD_MISMATCH')
