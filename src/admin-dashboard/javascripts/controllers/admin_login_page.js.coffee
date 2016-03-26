angular.module('BBAdminDashboard').controller 'bbAdminLoginPageController', ($scope,
    AdminLoginService, $state, $timeout) ->

  if AdminLoginService.isLoggedIn()
    AdminLoginService.logout()

  $scope.loginSuccess = (company) ->
    $scope.company = company
    $scope.bb.company = company
    $state.go 'dashboard'

