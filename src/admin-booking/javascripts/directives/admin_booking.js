// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.

angular.module('BBAdminBooking').directive('bbAdminBooking', function (BBModel, $log, $compile, $q, PathSvc, $templateCache, $http) {

    let getTemplate = function (template) {
        let partial = template ? template : 'main';
        return $templateCache.get(partial + '.html');
    };

    let renderTemplate = (scope, element, design_mode, template) =>
            $q.when(getTemplate(template)).then(function (template) {
                element.html(template).show();
                if (design_mode) {
                    element.append('<style widget_css scoped></style>');
                }
                return $compile(element.contents())(scope);
            })
        ;

    let link = function (scope, element, attrs) {
        let config = scope.$eval(attrs.bbAdminBooking);
        if (!config) {
            config = {};
        }
        config.admin = true;
        if (!attrs.companyId) {
            if (config.company_id) {
                attrs.companyId = config.company_id;
            } else if (scope.company) {
                attrs.companyId = scope.company.id;
            }
        }
        if (attrs.companyId) {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.company = company;
                scope.initWidget(config);
                return renderTemplate(scope, element, config.design_mode, config.template);
            });
        }
    };

    return {
        link,
        controller: 'BBCtrl',
        controllerAs: '$bbCtrl',
        scope: true
    };
});

