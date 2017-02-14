// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('ngValidInclude', $compile =>
    ({
        link(scope, element, attr) {
            return scope[attr.watchValue].then(logged => {
                    element.attr('ng-include', attr.ngValidInclude);
                    element.attr('ng-valid-include', null);
                    return $compile(element)(scope);
                }
            );
        }
    })
);
