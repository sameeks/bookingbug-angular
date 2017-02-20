angular.module('BBAdminBooking').directive('bbAdminMoveBooking', function ($log,
                                                                           $compile, $q, PathSvc, $templateCache, $http, BBModel, $rootScope) {

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
                return scope.decideNextPage("calendar");
            })
        ;


    let link = function (scope, element, attrs) {

        let config = scope.$eval(attrs.bbAdminMoveBooking);
        if (!config) {
            config = {};
        }
        config.no_route = true;
        config.admin = true;
        if (!config.template) {
            config.template = "main";
        }
        if (!attrs.companyId) {
            if (config.company_id) {
                attrs.companyId = config.company_id;
            } else if (scope.company) {
                attrs.companyId = scope.company.id;
            }
        }
        if (attrs.companyId) {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.initWidget(config);
                return company.getBooking(config.booking_id).then(function (booking) {
                    scope.company = company;
                    scope.bb.moving_booking = booking;
                    scope.quickEmptybasket();
                    let proms = [];
                    let new_item = new BBModel.BasketItem(booking, scope.bb);
                    new_item.setSrcBooking(booking, scope.bb);
                    new_item.clearDateTime();
                    new_item.ready = false;

                    if (booking.$has('client')) {
                        let client_prom = booking.$get('client');
                        proms.push(client_prom);
                        client_prom.then(client => {
                                return scope.setClient(new BBModel.Client(client));
                            }
                        );
                    }

                    Array.prototype.push.apply(proms, new_item.promises);
                    scope.bb.basket.addItem(new_item);
                    scope.setBasketItem(new_item);

                    return $q.all(proms).then(function () {
                            $rootScope.$broadcast("booking:move");
                            scope.setLoaded(scope);
                            return renderTemplate(scope, element, config.design_mode, config.template);
                        }
                        , function (err) {
                            scope.setLoaded(scope);
                            return failMsg();
                        });
                });
            });
        }
    };


    return {
        link,
        controller: 'BBCtrl',
        controllerAs: '$bbCtrl'
    };
});

