'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.settings-iframe.controllers.controller:ConfigIframePageCtrl
#
* @description
* Controller for the settings page
###
angular.module('BBAdminDashboard.settings-iframe.controllers')
.controller 'ConfigIframePageCtrl',['$scope', '$state', '$rootScope', ($scope, $state, $rootScope) ->

  $scope.parent_state = $state.is("config")
  $scope.path = "edit"

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    $scope.parent_state = false
    if (toState.name == "config")
      $scope.parent_state = true
]