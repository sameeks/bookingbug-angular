// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbQuestionLine', $compile => {
        return {
            transclude: false,
            restrict: 'A',
            link(scope, element, attrs) {
                if (scope.question.detail_type === "heading") {
                    let elm = "";
                    if (scope.question.name.length > 0) {
                        elm += `<div class='bb-question-heading'>${scope.question.name}</div>`;
                    }
                    if (scope.question.help_text && (scope.question.help_text.length > 0)) {
                        elm += `<div class='bb-question-help-text'>${scope.question.help_text}</div>`;
                    }
                    element.html(elm);
                }

                // are we using a completely custom question
                if (scope.idmaps && ((scope.idmaps[scope.question.detail_type] && scope.idmaps[scope.question.detail_type].block) ||
                    (scope.idmaps[scope.question.id] && scope.idmaps[scope.question.id].block))) {
                    let e;
                    let index = scope.idmaps[scope.question.id] ? scope.question.id : scope.question.detail_type;
                    let {html} = scope.$parent.idmaps[index];
                    return e = $compile(html)(scope, (cloned, scope) => {
                            return element.replaceWith(cloned);
                        }
                    );
                }
            }
        };
    }
);
