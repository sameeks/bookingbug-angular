
angular.module('BBAdminBooking').directive('bbAdminBookingPopup', AdminBookingPopup =>
  ({
    restrict: 'A',
    link(scope, element, attrs) {

      return element.bind('click', () => scope.open());
    },

    controller($scope) {

      return $scope.open = () => AdminBookingPopup.open();
    }
  })
);

