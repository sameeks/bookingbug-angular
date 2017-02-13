// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// Min/Max directives for use with number inputs
// Although angular provides min/max directives when using a HTML number input, the control does not validate if the field is actually a number
// so we have to use a text input with a ng-pattern that only allows numbers.
// http://jsfiddle.net/g/s5gKC/

angular.module('BB.Directives').directive("ngMin", () =>
  ({
    restrict: "A",
    require: "ngModel",
    link(scope, elem, attr, ctrl) {

      let minValidator = function(value) {
        let min = scope.$eval(attr.ngMin) || 0;
        ctrl.$setValidity("ngMin", (angular.isUndefined(value) || (value === "") || (value === null) || (value !== value)) || (value >= min));
        return value;
      };

      ctrl.$parsers.push(minValidator);
      ctrl.$formatters.push(minValidator);
    }
  })
);
