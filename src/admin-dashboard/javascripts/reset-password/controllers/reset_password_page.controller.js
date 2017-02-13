'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.reset-password.controller:ResetPasswordPageCtrl
#
* @description
* Controller for the reset password page
###

ResetPasswordPageCtrl = ($scope) ->
  'ngInject'

  init = () ->

    if $scope.bb.api_url? and $scope.bb.api_url != ''
      $scope.baseUrl = angular.copy($scope.bb.api_url)

    return

  init()

  return

angular
  .module('BBAdminDashboard.reset-password')
  .controller('ResetPasswordPageCtrl', ResetPasswordPageCtrl)
