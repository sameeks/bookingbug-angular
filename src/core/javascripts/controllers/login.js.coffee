
angular.module('BB.Directives').directive 'bbLogin', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'Login'


angular.module('BB.Controllers').controller 'Login', ($scope,  $rootScope, LoginService, $q, ValidatorService, BBModel, $location, AlertService, ErrorService) ->
  $scope.controller = "public.controllers.Login"
  $scope.error = false
  $scope.password_updated = false
  $scope.password_error = false
  $scope.email_sent = false
  $scope.success = false
  $scope.login_error = false
  $scope.validator = ValidatorService

  $scope.login_sso = (token, route) ->
    $rootScope.connection_started.then =>
      LoginService.ssoLogin({company_id: $scope.bb.company.id, root: $scope.bb.api_url}, {token: token}).then (member) =>
        $scope.showPage(route) if route
      , (err) -> $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')
    , (err) ->  $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong')


  $scope.login_with_password = (email, password) ->
    $scope.login_error = false
    LoginService.companyLogin($scope.bb.company, {}, {email: email, password: password}).then (member) =>
      $scope.member = new BBModel.Member.Member(member)
      $scope.success = true
      $scope.login_error = false
    , (err) =>
      $scope.login_error = err
      AlertService.raise(ErrorService.getAlert('LOGIN_FAILED'))


  $scope.showEmailPasswordReset = () =>
    $scope.showPage('email_reset_password')


  $scope.isLoggedIn = () ->
    LoginService.isLoggedIn()


  $scope.sendPasswordReset = (email) ->
    $scope.error = false
    LoginService.sendPasswordReset($scope.bb.company, {email: email, custom: true}).then () ->
      $scope.email_sent = true
      AlertService.raise(ErrorService.getAlert('PASSWORD_RESET_REQ_SUCCESS'))
    , (err) =>
      $scope.error = err
      AlertService.raise(ErrorService.getAlert('PASSWORD_RESET_REQ_FAILED'))


  $scope.updatePassword = (new_password, confirm_new_password) ->
    AlertService.clear()
    $scope.password_error = false
    $scope.error = false
    if $rootScope.member and new_password and confirm_new_password and (new_password is confirm_new_password)
      LoginService.updatePassword($rootScope.member, {new_password: new_password, confirm_new_password: confirm_new_password}).then (member) =>
        if member
          $scope.password_updated = true
          $scope.setClient(member)
          AlertService.raise(ErrorService.getAlert('PASSWORD_RESET_SUCESS'))
          $rootScope.$emit "login:password_reset"
      , (err) =>
        $scope.error = err
        AlertService.raise(ErrorService.getAlert('PASSWORD_RESET_FAILED'))
    else
      $scope.password_error = true
      AlertService.raise(ErrorService.getAlert('PASSWORD_MISMATCH'))