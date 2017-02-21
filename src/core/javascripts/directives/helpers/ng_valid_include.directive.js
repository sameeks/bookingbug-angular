angular.module('BB.Directives').directive('ngValidInclude', $compile => {
        return {
            link(scope, element, attr) {
                return scope[attr.watchValue].then(logged => {
                        element.attr('ng-include', attr.ngValidInclude);
                        element.attr('ng-valid-include', null);
                        return $compile(element)(scope);
                    }
                );
            }
        };
    }
);
