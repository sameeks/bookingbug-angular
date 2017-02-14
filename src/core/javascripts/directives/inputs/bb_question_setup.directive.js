// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbQuestionSetup', () =>
    ({
        restrict: 'A',
        terminal: true,
        priority: 1000,

        link(scope, element, attrs) {
            let idmaps = {};
            let def = null;
            let iterable = element.children();
            for (let index = 0; index < iterable.length; index++) {
                let child = iterable[index];
                let id = $(child).attr("bb-question-id");
                let block = false;
                if ($(child).attr("bb-replace-block")) {
                    block = true;
                }
                // replace form name with something unique to ensure custom questions get registered
                // with the form controller and subjected to validation
                child.innerHTML = child.innerHTML.replace(/question_form/g, `question_form_${index}`);
                idmaps[id] = {id, html: child.innerHTML, block};
            }
            scope.idmaps = idmaps;
            return element.replaceWith("");
        }
    })
);
