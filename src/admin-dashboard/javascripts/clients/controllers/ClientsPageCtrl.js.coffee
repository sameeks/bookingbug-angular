'use strict'

###
* @ngdoc controller
* @name BBAdminDashboard.clients.controllers.controller:ClientsPageCtrl
#
* @description
* Controller for the clients page
###
angular.module('BBAdminDashboard.clients.controllers')
.controller 'ClientsPageCtrl',['$scope', '$state', ($scope, $state) ->
  
  $scope.adminlte.heading = null
  $scope.clientsOptions = {search: null}
  $scope.adminlte.side_menu = true

  $scope.set_current_client = (client) ->
    $scope.current_client = client

]
