// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('ngInitial', () =>
    ({
        restrict: 'A',
        controller: [
            '$scope', '$element', '$attrs', '$parse', function ($scope, $element, $attrs, $parse) {
                let val = $attrs.ngInitial || $attrs.value;
                let getter = $parse($attrs.ngModel);
                let setter = getter.assign;
                if (val === "true") {
                    val = true;
                } else if (val === "false") {
                    val = false;
                }
                return setter($scope, val);
            }
        ]
    }));
