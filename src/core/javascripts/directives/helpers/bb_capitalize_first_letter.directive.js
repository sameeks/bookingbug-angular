// bbCapitaliseFirstLetter
angular.module('BB.Directives').directive('bbCapitaliseFirstLetter', () =>
  ({
    restrict: 'A',
    require: ['ngModel'],
    link(scope, element, attrs, ctrls) {
      let ngModel = ctrls[0];

      return scope.$watch(attrs.ngModel, function(newval, oldval) {
        if (newval) {
          let string = scope.$eval(attrs.ngModel);
          string = string.charAt(0).toUpperCase() + string.slice(1);
          ngModel.$setViewValue(string);
          ngModel.$render();
          return;
        }
      });
    }
  })
);
