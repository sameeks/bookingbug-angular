'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.logout.controllers.controller:LogoutPageCtrl
#
* @description
* Controller for the logout page
###
angular.module('BBAdminDashboard.logout.controllers')
.controller 'LogoutPageCtrl', (BBModel, $scope, $state, $sessionStorage) ->
  BBModel.Admin.Login.$logout().then ()->
    $sessionStorage.removeItem("user")
    $sessionStorage.removeItem("auth_token")
    $state.go 'login', {}, {reload: true}
    return

  return
