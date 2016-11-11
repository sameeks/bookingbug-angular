'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.reset-password.controllers.controller:resetPasswordPageCtrl
#
* @description
* Controller for the logout page
###
angular.module('BBAdminDashboard.reset-password.controllers')
.controller 'resetPasswordPageCtrl', ($scope, $state) ->
  'ngInject'

  if $scope.bb.api_url? and $scope.bb.api_url != ''
    $scope.BaseURL = angular.copy($scope.bb.api_url)

  return
