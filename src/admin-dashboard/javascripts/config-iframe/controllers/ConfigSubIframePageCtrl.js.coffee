'use strict'

###
* @ngdoc controller
* @name BBAdminDashboard.config-iframe.controllers.controller:ConfigSubIframePageCtrl
#
* @description
* Controller for the config sub page
###
angular.module('BBAdminDashboard.config-iframe.controllers')
.controller 'ConfigSubIframePageCtrl',['$scope', '$state', '$stateParams', ($scope, $state, $stateParams) ->
  $scope.path = $stateParams.path
]
