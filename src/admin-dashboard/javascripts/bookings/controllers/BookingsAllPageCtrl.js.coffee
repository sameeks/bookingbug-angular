'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.bookings.controllers.controller:BookingsAllPageCtrl
#
* @description
* Controller for the bookings all page
###
angular.module('BBAdminDashboard.bookings.controllers')
.controller 'BookingsAllPageCtrl',['$scope', '$state', ($scope, $state) ->
  $scope.set_current_booking(null)
]