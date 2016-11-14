'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.reset-password.controllers.controller:ResetPasswordPageCtrl
#
* @description
* Controller for the reset password page
###
angular.module('BBAdminDashboard.reset-password.controllers')
.controller 'ResetPasswordPageCtrl', ($scope, $state) ->
  'ngInject'

  if $scope.bb.api_url? and $scope.bb.api_url != ''
    $scope.base_url = angular.copy($scope.bb.api_url)

  return
