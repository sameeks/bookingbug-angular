// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('script', ($compile, halClient) => {
        return {
            transclude: false,
            restrict: 'E',
            link(scope, element, attrs) {
                if (attrs.type === 'text/hal-object') {
                    let res;
                    let body = element[0].innerText;
                    let json = $bbug.parseJSON(body);
                    return res = halClient.$parse(json);
                }
            }
        };
    }
);

