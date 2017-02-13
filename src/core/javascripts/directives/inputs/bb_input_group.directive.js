// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive("bbInputGroup", () =>
  ({
    restrict: "A",
    require: 'ngModel',
    link(scope, elem, attrs, ngModel) {

      // return if the input has already been registered
      if (scope.input_manger.inputs.indexOf(ngModel.$name) >= 0) { return; }

      // register the input
      scope.input_manger.registerInput(ngModel, attrs.bbInputGroup);

      // watch the input for changes
      return scope.$watch(attrs.ngModel, function(newval, oldval) {
        if (newval === !oldval) { return scope.input_manger.validateInputGroup(attrs.bbInputGroup); }
      });
    }
  })
);
