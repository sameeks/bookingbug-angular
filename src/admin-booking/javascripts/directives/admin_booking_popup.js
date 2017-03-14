angular.module('BBAdminBooking').directive('bbAdminBookingPopup', WidgetModalService => {
        return {
            restrict: 'A',
            link(scope, element, attrs) {
                console.log('is this being used');

                return element.bind('click', () => scope.open());
            },

            controller($scope) {

                return $scope.open = () => WidgetModalService.open();
            }
        };
    }
);

