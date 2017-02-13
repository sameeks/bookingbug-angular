// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbQuestionLabel', $compile =>
  ({
    transclude: false,
    restrict: 'A',
    scope: false,
    link(scope, element, attrs) {
      return scope.$watch(attrs.bbQuestionLabel, function(question) {
        if (question) {
          if ((question.detail_type === "check") || (question.detail_type === "check-price")) {
            return element.html("");
          }
        }
      });
    }
  })
);
