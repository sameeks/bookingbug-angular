angular.module('BB.Directives').directive('script', ($compile, halClient) => {
        return {
            transclude: false,
            restrict: 'E',
            link(scope, element, attrs) {
                if (attrs.type === 'text/hal-object') {
                    let body = element[0].innerText;
                    let json = $bbug.parseJSON(body);
                    return halClient.$parse(json);
                }
            }
        };
    }
);

