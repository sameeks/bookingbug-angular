angular.module('BB.Directives').directive('bbQuestionLabel', $compile => {
        return {
            transclude: false,
            restrict: 'A',
            scope: false,
            link(scope, element, attrs) {
                return scope.$watch(attrs.bbQuestionLabel, function (question) {
                    if (question) {
                        if ((question.detail_type === "check") || (question.detail_type === "check-price")) {
                            return element.html("");
                        }
                    }
                });
            }
        };
    }
);
