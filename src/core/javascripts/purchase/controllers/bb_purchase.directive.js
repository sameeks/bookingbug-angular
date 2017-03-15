(() => {

    angular
        .module('BB.Directives')
        .directive('bbPurchase', BBPurchase)


    function BBPurchase() {
        let directive = {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Purchase',
            link
        }

        return directive;

        function link(scope, element, attrs) {
            scope.init(scope.$eval(attrs.bbPurchase));
        }
    }

})();
