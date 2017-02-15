angular.module('BB.Directives').directive('bbQuestionLink', $compile => {
        return {
            transclude: false,
            restrict: 'A',
            scope: true,
            link(scope, element, attrs) {
                let id = parseInt(attrs.bbQuestionLink);
                return scope.$watch("question_set", function (newval, oldval) {
                    if (newval) {
                        return (() => {
                            let result = [];
                            for (let q of Array.from(scope.question_set)) {
                                let item;
                                if (q.id === id) {
                                    scope.question = q;
                                    element.attr('ng-model', "question.answer");
                                    element.attr('bb-question-link', null);
                                    item = $compile(element)(scope);
                                }
                                result.push(item);
                            }
                            return result;
                        })();
                    }
                });
            }
        };
    }
);
