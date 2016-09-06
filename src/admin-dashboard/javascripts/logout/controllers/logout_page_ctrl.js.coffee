'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.logout.controllers.controller:LogoutPageCtrl
#
* @description
* Controller for the logout page
###
angular.module('BBAdminDashboard.logout.controllers')
.controller 'LogoutPageCtrl',['$scope', '$state', 'BBModel', ($scope, $state, BBModel) ->
  BBModel.Admin.Login.$logout().then ()->
  	$state.go 'login', {}, {reload: true}

]