angular.module('BB.Directives').directive('bbPurchase', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Purchase',
            link(scope, element, attrs) {
                scope.init(scope.$eval(attrs.bbPurchase));
            }
        };
    }
);

angular.module('BB.Controllers').controller('Purchase', function ($scope, $rootScope,
                                                                  PurchaseService, $uibModal, $location, $timeout, BBModel, $q, QueryStringService,
                                                                  SSOService, AlertService, LoginService, $window, $sessionStorage, LoadingService,
                                                                  $translate, ReasonService, $document) {

    let setCancelReasonsToBB;
    $scope.is_waitlist = false;
    $scope.make_payment = false;
    let loader = LoadingService.$loader($scope);

    $scope.$on('booking:moved', (event, purchase) => {
        $scope.purchase = purchase;
    });

    let setPurchaseCompany = function (company) {

        $scope.bb.company_id = company.id;
        $scope.bb.company = new BBModel.Company(company);
        $scope.company = $scope.bb.company;
        $scope.bb.item_defaults.company = $scope.bb.company;
        if (company.settings) {
            if (company.settings.merge_resources) {
                $scope.bb.item_defaults.merge_resources = true;
            }
            if (company.settings.merge_people) {
                return $scope.bb.item_defaults.merge_people = true;
            }
        }
    };


    let failMsg = function () {

        if ($scope.fail_msg) {
            return AlertService.danger({msg: $scope.fail_msg});
        } else {
            return AlertService.add("danger", {msg: $translate.instant('CORE.ALERTS.GENERIC')});
        }
    };


    $scope.init = function (options) {

        if (!options) {
            options = {};
        }

        loader.notLoaded();
        if (options.move_route) {
            $scope.move_route = options.move_route;
        }
        if (options.move_all) {
            $scope.move_all = options.move_all;
        }
        if (options.fail_msg) {
            $scope.fail_msg = options.fail_msg;
        }

        // is there a purchase total already in scope?
        if ($scope.bb.total) {
            return $scope.load($scope.bb.total.long_id);
        } else if ($scope.bb.purchase) {
            $scope.purchase = $scope.bb.purchase;
            $scope.bookings = $scope.bb.purchase.bookings;
            if ($scope.purchase.confirm_messages) {
                $scope.messages = $scope.purchase.confirm_messages;
            }
            if (!$scope.cancel_reasons) {
                $scope.cancel_reasons = $scope.bb.cancel_reasons;
            }
            if (!$scope.move_reasons) {
                $scope.move_reasons = $scope.bb.move_reasons;
            }
            return loader.setLoaded();
        } else {
            if (options.member_sso) {
                return SSOService.memberLogin(options).then(login => $scope.load()
                    , function (err) {
                        loader.setLoaded();
                        return failMsg();
                    });
            } else {
                return $scope.load();
            }
        }
    };

    let getPurchase = function (params) {

        let deferred = $q.defer();
        PurchaseService.query(params).then(function (purchase) {
                deferred.resolve(purchase);
                purchase.$get('company').then(company => {
                        return setPurchaseCompany(company);
                    }
                );
                $scope.purchase = purchase;
                $scope.bb.purchase = purchase;
                return $scope.price = !($scope.purchase.price === 0);
            }
            , function (err) { //get purchase
                loader.setLoaded();
                if (err && (err.status === 401)) {
                    if (LoginService.isLoggedIn()) {
                        // TODO don't show fail message, display message that says you're logged in as someone else and offer switch user function (logout and show login)
                        return failMsg();
                    } else {
                        return loginRequired();
                    }
                } else {
                    return failMsg();
                }
            });
        return deferred.promise;
    };

    let getBookings = function (purchase) {

        $scope.purchase.$getBookings().then((bookings) => {
                $scope.bookings = bookings;

                if (bookings[0]) {
                    bookings[0].$getCompany().then((company) => {
                        $scope.purchase.bookings[0].company = company;
                        $rootScope.$broadcast("purchase:loaded", company.id);
                        return company.$getAddress().then(address => $scope.purchase.bookings[0].company.address = address);
                    });
                }

                loader.setLoaded();
                checkIfWaitlistBookings(bookings);

                return Array.from($scope.bookings).map((booking) =>
                    booking.$getAnswers().then(answers => booking.answers = answers));
            }
            , function (err) { //get booking
                loader.setLoaded();
                return failMsg();
            });

        if (purchase.$has('client')) {
            purchase.$get('client').then(client => {
                    return $scope.setClient(new BBModel.Client(client));
                }
            );
        }
        return $scope.purchase.getConfirmMessages().then(function (messages) {
            $scope.purchase.confirm_messages = messages;
            return $scope.messages = messages;
        });
    };

    $scope.load = function (id) {

        loader.notLoaded();

        if (!id) {
            id = getPurchaseID();
        }

        if (!$scope.loaded && !!id) {
            $rootScope.widget_started.then(() => {
                    return $scope.waiting_for_conn_started.then(() => {
                            let company_id = getCompanyID();
                            if (company_id) {
                                let options = {root: $scope.bb.api_url};
                                BBModel.Company.$query(company_id, options).then(company => setPurchaseCompany(company));
                            }
                            let params = {purchase_id: id, url_root: $scope.bb.api_url};
                            let auth_token = $sessionStorage.getItem('auth_token');
                            if (auth_token) {
                                params.auth_token = auth_token;
                            }

                            return getPurchase(params).then(purchase => getBookings(purchase));
                        }

                        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
                }
                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
        } else {
            loader.setLoaded();
        }

        return $scope.loaded = true;
    };


    var checkIfWaitlistBookings = bookings => $scope.waitlist_bookings = (Array.from(bookings).filter((booking) => (booking.on_waitlist && (booking.settings.sent_waitlist === 1))).map((booking) => booking));


    var loginRequired = () => {

        if (!$scope.bb.login_required) {
            return window.location = window.location.href + "&login=true";
        }
    };


    var getCompanyID = function () {

        let company_id;
        let matches = /^.*(?:\?|&)company_id=(.*?)(?:&|$)/.exec($location.absUrl());
        if (matches) {
            company_id = matches[1];
        }
        return company_id;
    };


    var getPurchaseID = function () {

        let id;
        let matches = /^.*(?:\?|&)id=(.*?)(?:&|$)/.exec($location.absUrl());
        if (!matches) {
            matches = /^.*print_purchase\/(.*?)(?:\?|$)/.exec($location.absUrl());
        }
        if (!matches) {
            matches = /^.*print_purchase_jl\/(.*?)(?:\?|$)/.exec($location.absUrl());
        }

        if (matches) {
            id = matches[1];
        } else {
            if (QueryStringService('ref')) {
                id = QueryStringService('ref');
            }
        }
        if (QueryStringService('booking_id')) {
            id = QueryStringService('booking_id');
        }
        return id;
    };


    // potentially move all of the items in booking - move the whole lot to a basket
    $scope.moveAll = function (route, options) {

        if (options == null) {
            options = {};
        }
        if (!route) {
            route = $scope.move_route;
        }
        loader.notLoaded();
        $scope.initWidget({company_id: $scope.bookings[0].company_id, no_route: true});
        return $timeout(() => {
                return $rootScope.connection_started.then(() => {
                        let proms = [];
                        if ($scope.bookings.length === 1) {
                            $scope.bb.moving_booking = $scope.bookings[0];
                        } else {
                            $scope.bb.moving_booking = $scope.purchase;
                        }

                        if (_.every(_.map($scope.bookings, b => b.event_id),
                                event_id => event_id === $scope.bookings[0].event_id)) {
                            $scope.bb.moving_purchase = $scope.purchase;
                        }

                        $scope.quickEmptybasket();
                        for (let booking of Array.from($scope.bookings)) {
                            let new_item = new BBModel.BasketItem(booking, $scope.bb);
                            new_item.setSrcBooking(booking);
                            new_item.ready = false;
                            new_item.move_done = false;
                            Array.prototype.push.apply(proms, new_item.promises);
                            $scope.bb.basket.addItem(new_item);
                        }
                        $scope.bb.sortStackedItems();

                        $scope.setBasketItem($scope.bb.basket.items[0]);
                        return $q.all(proms).then(function () {
                                loader.setLoaded();
                                return $scope.decideNextPage(route);
                            }
                            , function (err) {
                                loader.setLoaded();
                                return failMsg();
                            });
                    }
                    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
            }
        );
    };


    $scope.bookWaitlistItem = function (booking) {

        loader.notLoaded();

        let params = {
            purchase: $scope.purchase,
            booking
        };
        return PurchaseService.bookWaitlistItem(params).then(function (purchase) {
                $scope.purchase = purchase;
                $scope.total = $scope.purchase;
                $scope.bb.purchase = purchase;
                return $scope.purchase.$getBookings().then(function (bookings) {
                        $scope.bookings = bookings;
                        $scope.waitlist_bookings = ((() => {
                            let result = [];
                            for (booking of Array.from($scope.bookings)) {
                                if (booking.on_waitlist && (booking.settings.sent_waitlist === 1)) {
                                    result.push(booking);
                                }
                            }
                            return result;
                        })());
                        if ($scope.purchase.$has('new_payment') && ($scope.purchase.due_now > 0)) {
                            $scope.make_payment = true;
                        }
                        return loader.setLoaded();
                    }
                    , function (err) {
                        loader.setLoaded();
                        return failMsg();
                    });
            }

            , err => {
                return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
            }
        );
    };


    // delete a single booking
    $scope.delete = function (booking) {

        let modalInstance = $uibModal.open({
            templateUrl: $scope.getPartial("_cancel_modal"),
            controller: ModalDelete,
            resolve: {
                booking() {
                    return booking;
                },
                cancel_reasons() {
                    return $scope.cancel_reasons;
                }
            }
        });

        return modalInstance.result.then(function (booking) {
            let cancel_reason = null;
            if (booking.cancel_reason) {
                ({cancel_reason} = booking);
            }
            let data = {cancel_reason};
            return booking.$del('self', {}, data).then(service => {
                    $scope.bookings = _.without($scope.bookings, booking);
                    return $rootScope.$broadcast("booking:cancelled");
                }
            );
        });
    };


    // delete all bookings assoicated to the purchase
    $scope.deleteAll = function () {

        let modalInstance = $uibModal.open({
            templateUrl: $scope.getPartial("_cancel_modal"),
            controller: ModalDeleteAll,
            resolve: {
                purchase() {
                    return $scope.purchase;
                }
            }
        });
        return modalInstance.result.then(purchase =>
            PurchaseService.deleteAll(purchase).then(function (purchase) {
                $scope.purchase = purchase;
                $scope.bookings = [];
                return $rootScope.$broadcast("booking:cancelled");
            })
        );
    };

    $scope.createBasketItem = function (booking) {

        let item = new BBModel.BasketItem(booking, $scope.bb);
        item.setSrcBooking(booking);
        return item;
    };


    $scope.checkAnswer = answer => (typeof answer.value === 'boolean') || (typeof answer.value === 'string') || (typeof answer.value === "number");


    $scope.changeAttendees = route => $scope.moveAll(route);


    var setMoveReasonsToBB = function () {

        if ($scope.move_reasons) {
            return $scope.bb.move_reasons = $scope.move_reasons;
        }
    };

    return setCancelReasonsToBB = function () {

        if ($scope.cancel_reasons) {
            return $scope.bb.cancel_reasons = $scope.cancel_reasons;
        }
    };
});


// Simple modal controller for handling the 'delete' modal
var ModalDelete = function ($scope, $rootScope, $uibModalInstance, booking, AlertService, cancel_reasons) {
    $scope.booking = booking;
    $scope.cancel_reasons = cancel_reasons;

    $scope.confirmDelete = function () {
        AlertService.clear();
        return $uibModalInstance.close(booking);
    };

    return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
};

// Simple modal controller for handling the 'delete all' modal
var ModalDeleteAll = function ($scope, $rootScope, $uibModalInstance, purchase) {
    $scope.purchase = purchase;

    $scope.confirmDelete = () => $uibModalInstance.close(purchase);

    return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
};
