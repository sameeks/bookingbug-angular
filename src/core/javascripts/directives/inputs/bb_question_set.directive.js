// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbQuestionSet', $compile =>
    ({
        transclude: false,
        restrict: 'A',
        scope: true,
        link(scope, element, attrs) {
            let set = attrs.bbQuestionSet;
            element.addClass('ng-hide');
            return scope.$watch(set, function (newval, oldval) {
                if (newval) {
                    scope.question_set = newval;
                    return element.removeClass('ng-hide');
                }
            });
        }
    })
);
