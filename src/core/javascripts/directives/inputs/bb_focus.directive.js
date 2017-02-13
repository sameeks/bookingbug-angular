// Directive for testing if a input is focused
// Provided by http://www.ng-newsletter.com/posts/validations.html
angular.module('BB.Directives').directive("bbFocus", [function() {
    let FOCUS_CLASS = "bb-focused";
    return {
      restrict: "A",
      require: "ngModel",
      link(scope, element, attrs, ctrl) {
        ctrl.$focused = false;
        return element.bind("focus", function(evt) {
          element.addClass(FOCUS_CLASS);
          return scope.$apply(() => ctrl.$focused = true);}).bind("blur", function(evt) {
          element.removeClass(FOCUS_CLASS);
          return scope.$apply(() => ctrl.$focused = false);
        });
      }
    };
  }
]);
