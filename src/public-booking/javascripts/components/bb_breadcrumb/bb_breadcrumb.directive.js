angular.module('BB.Directives').directive('bbBreadcrumbs', PathSvc => {
        return {
            restrict: 'A',
            replace: true,
            scope: true,
            controller: 'Breadcrumbs',
            templateUrl(element, attrs) {
                if (_.has(attrs, 'complex')) {
                    return PathSvc.directivePartial("_breadcrumb_complex");
                } else {
                    return PathSvc.directivePartial("_breadcrumb");
                }
            },

            link(scope) {

            }
        };
    }
);
