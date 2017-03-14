(() => {

    angular
        .module('BB.Directives')
        .directive('bbMoveBooking', MoveBooking);

        function MoveBooking() {
            let directive = {
                scope: true,
                controller: 'bbMoveBookingController',
                controllerAs: '$bbMoveBookingCtrl'
            }

            return directive;
        }


})();
