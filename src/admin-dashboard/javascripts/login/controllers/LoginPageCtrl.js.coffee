'use strict'

###
* @ngdoc controller
* @name BBAdminDashboard.login.controllers.controller:LoginPageCtrl
#
* @description
* Controller for the login page
###
angular.module('BBAdminDashboard.login.controllers')
.controller 'LoginPageCtrl', ($scope, $state, AdminLoginService) ->

  if AdminLoginService.isLoggedIn()
    AdminLoginService.logout()

  $scope.loginSuccess = (company) ->
    $scope.company = company
    $scope.bb.company = company
    $state.go 'calendar'

