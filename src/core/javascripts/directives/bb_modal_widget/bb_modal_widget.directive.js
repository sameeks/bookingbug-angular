angular
    .module('BB.Directives')
    .directive('bbModalWidget', modalWidget);

function modalWidget(BBModel, $log, $compile, $q, PathSvc, $templateCache, $http) {

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
                $compile(element.contents())(scope);
            });


    let link = function(scope, element, attrs) {
        let config = scope.$eval(attrs.bbModalWidget);
        scope.initWidget(config);
        return renderTemplate(scope, element, config.design_mode, config.template);
    };

    let directive = {
        link: link,
        controller: 'BBCtrl',
        controllerAs: '$bbCtrl',
        scope: true
    }

    return directive;
};

