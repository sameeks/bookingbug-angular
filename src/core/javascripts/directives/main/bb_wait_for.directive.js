angular.module('BB.Directives').directive('bbWaitFor', $compile => {
        return {
            transclude: false,
            restrict: 'A',
            priority: 800,
            link(scope, element, attrs) {
                let name = attrs.bbWaitVar;
                if (!name) {
                    name = "allDone";
                }
                scope[name] = false;
                let prom = scope.$eval(attrs.bbWaitFor);
                if (!prom) {
                    scope[name] = true;
                } else {
                    prom.then(() => scope[name] = true);
                }
            }
        };
    }
);
