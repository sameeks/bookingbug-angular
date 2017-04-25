(function () {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientTabSet', bbClientTabSet);

    function bbClientTabSet() {
        const directive = {
            templateUrl: 'clients/tabset.html'
        };

        return directive;
    }

})();

