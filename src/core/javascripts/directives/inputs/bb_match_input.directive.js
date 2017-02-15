// Input match test
angular.module('BB.Directives').directive("bbMatchInput", () => {
        return {
            restrict: "A",
            require: 'ngModel',
            link(scope, element, attrs, ctrl, ngModel) {

                scope.$watch(attrs.bbMatchInput, function () {
                    scope.val_1 = scope.$eval(attrs.bbMatchInput);
                    return compare(ctrl.$viewValue);
                });

                var compare = function (value) {
                    ctrl.$setValidity('match', scope.val_1 === value);
                    return value;
                };

                return ctrl.$parsers.push(compare);
            }
        };
    }
);
