// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbPadWithZeros
// Adds a formatter that prepends the model value with the specified number of zeros
angular.module('BB.Directives').directive('bbPadWithZeros', () =>
    ({
        restrict: 'A',
        require: 'ngModel',
        link(scope, element, attrs, ctrl) {

            let options = scope.$eval(attrs.bbPadWithZeros) || {};
            let how_many = options.how_many || 2;

            let padNumber = function (value) {
                value = String(value);
                if (value && (value.length < how_many)) {
                    let padding = "";
                    for (let index = 1, end = how_many - value.length, asc = 1 <= end; asc ? index <= end : index >= end; asc ? index++ : index--) {
                        padding += "0";
                    }
                    value = padding.concat(value);
                }
                return value;
            };

            return ctrl.$formatters.push(padNumber);
        }
    })
);
