angular.module('BBAdmin.Controllers').controller 'SelectedBookingDetails',
  ($scope, $location, $rootScope, BBModel) ->

  $scope.$watch 'selectedBooking', (newValue, oldValue) =>
    if newValue
      $scope.booking = newValue
      $scope.showItemView = "/view/dash/booking_details"
#      $scope.bookings = BBModel.Admin.Booking.$query({company_id: $scope.bb.company_id, slot: newValue})
#      $scope.bookings.then (bkngs) =>
#        if bkngs.items.length > 0
#          $scope.booking = bkngs.items[0]
#          $scope.showItemView = "/view/dash/booking_details"
