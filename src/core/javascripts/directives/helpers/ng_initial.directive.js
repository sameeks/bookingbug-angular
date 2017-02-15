angular.module('BB.Directives').directive('ngInitial', () => {
        return {
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
        };
    }
);
