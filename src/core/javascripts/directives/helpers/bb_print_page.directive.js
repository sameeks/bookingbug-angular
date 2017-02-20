angular.module('BB.Directives').directive('bbPrintPage', ($window, $timeout) => {
        return {
            restrict: 'A',
            link(scope, element, attr) {
                if (attr.bbPrintPage) {
                    return scope.$watch(attr.bbPrintPage, (newVal, oldVal) => {
                            return $timeout(() => $window.print(),
                                3000);
                        }
                    );
                }
            }
        };
    }
);
