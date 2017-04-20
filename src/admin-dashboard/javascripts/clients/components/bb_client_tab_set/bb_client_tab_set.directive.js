(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientTabSet', bbClientTabSet);

    function bbClientTabSet() {
        let directive = {
            templateUrl: 'clients/tabset.html',
            scope: false
        }

        return directive;
    }

})();
