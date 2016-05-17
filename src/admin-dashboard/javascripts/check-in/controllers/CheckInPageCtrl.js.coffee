'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.check-in.controllers.controller:CheckInPageCtrl
#
* @description
* Controller for the check-in page
###
angular.module('BBAdminDashboard.check-in.controllers')
.controller 'CheckInPageCtrl',['$scope', '$state', ($scope, $state) ->
  $scope.adminlte.heading = 'Check-in'
]