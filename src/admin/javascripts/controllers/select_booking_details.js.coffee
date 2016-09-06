'use strict'

angular.module('BBAdmin.Controllers').controller 'SelectedBookingDetails', (
  $scope, $location, $rootScope, BBModel) ->

  $scope.$watch 'selectedBooking', (newValue, oldValue) =>
    if newValue
      $scope.booking = newValue
      $scope.showItemView = "/view/dash/booking_details"

