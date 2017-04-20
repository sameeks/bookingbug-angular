(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientTabSet', bbClientTabSet);

    function bbClientTabSet() {
        let directive = {
            templateUrl: 'clients/tabset.html',
            link
        }

        return directive;

        function link(scope, elem, attrs) {
            console.log(scope)
        }
    }

})();

