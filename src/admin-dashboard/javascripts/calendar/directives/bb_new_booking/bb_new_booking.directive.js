(() => {

    angular
        .module('BBAdminDashboard.calendar.directives')
        .directive('bbNewBooking', bbNewBooking);

    function bbNewBooking() {
        let directive = {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'bbNewBookingCtrl'
        }

        return directive;
    }

})();
