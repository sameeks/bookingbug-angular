/***
 * @ngdoc directive
 * @name BBAdminDashboard.check-in.directives:bbAddWalkin
 * @restrict AE
 * @replace true
 * @scope true
 *
 * @description
 *
 * Intitialises modal to create a walk-in appointment
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 */

(() => {

    angular
        .module('BBAdminDashboard.check-in.directives')
        .directive('bbAddWalkin', bbAddWalkin);

    function bbAddWalkin() {
        let directive = {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'bbAddWalkinCtrl',
            controllerAs: '$bbAddWalkinCtrl'
        }

        return directive;
    }

})();
