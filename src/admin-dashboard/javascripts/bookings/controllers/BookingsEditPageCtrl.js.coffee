'use strict';

###
* @ngdoc controller
* @name BBAdminDashboard.bookings.controllers.controller:BookingsEditPageCtrl
#
* @description
* Controller for the bookings edit page
###
angular.module('BBAdminDashboard.bookings.controllers')
.controller 'BookingsEditPageCtrl',['$scope', 'booking', '$state', 'company', 'AdminBookingService', ($scope, client, $state, company, AdminBookingService) ->
  $scope.booking = booking

  # Refresh Client Resource after save
  $scope.bookingSaveCallback = ()->
    params =
      company_id: company.id
      id: $state.params.id
      flush: true

    AdminBookingService.query(params).then (booking)->
      $scope.booking = booking

]