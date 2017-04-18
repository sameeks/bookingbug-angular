/***
 * @ngdoc directive
 * @name BBAdminDashboard.calendar.directives:bbNewBooking
 * @restrict AE
 * @replace true
 * @scope true
 *
 * @description
 *
 * Initialises modal to create an appointment booking
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 */

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
