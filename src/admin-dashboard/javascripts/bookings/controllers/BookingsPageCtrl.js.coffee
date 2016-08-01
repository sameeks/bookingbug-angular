'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.clients.bookings.controller:BookingsPageCtrl
#
* @description
* Controller for the clients page
###
angular.module('BBAdminDashboard.bookings.controllers')
.controller 'BookingsPageCtrl',['$scope', '$state', ($scope, $state) ->

  $scope.bookingsOptions = {search: null}

  $scope.set_current_booking = (booking) ->
    $scope.current_booking = booking

]