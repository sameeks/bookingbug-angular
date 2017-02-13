angular.module('BBAdmin.Controllers').controller('SelectedBookingDetails', (
  $scope, $location, $rootScope, BBModel) =>

  $scope.$watch('selectedBooking', (newValue, oldValue) => {
    if (newValue) {
      $scope.booking = newValue;
      return $scope.showItemView = "/view/dash/booking_details";
    }
  }
  )
);

