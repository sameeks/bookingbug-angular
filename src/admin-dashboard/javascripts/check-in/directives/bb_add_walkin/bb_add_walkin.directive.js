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
