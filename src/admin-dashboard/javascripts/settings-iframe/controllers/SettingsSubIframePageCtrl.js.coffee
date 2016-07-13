'use strict'

###
* @ngdoc controller
* @name BBAdminDashboard.settings-iframe.controllers.controller:SettingsSubIframePageCtrl
#
* @description
* Controller for the settings sub page
###
angular.module('BBAdminDashboard.settings-iframe.controllers')
.controller 'SettingsSubIframePageCtrl',['$scope', '$state', '$stateParams', ($scope, $state, $stateParams) ->
  $scope.path = $stateParams.path
  if $stateParams.id
    $scope.extra_params = "id=#{$stateParams.id}"
  else
    $scope.extra_params = ""
]
