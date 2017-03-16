(() => {

    angular
        .module('BB.Controllers')
        .controller('Purchase', Purchase);

    function Purchase($scope, $rootScope, PurchaseService, $uibModal, $location, $timeout, BBModel,
        $q, QueryStringService, SSOService, AlertService, LoginService, $window, $sessionStorage,
        LoadingService, $translate, ReasonService, $document, GeneralOptions) {

        this.is_waitlist = false;
        this.make_payment = false;
        let loader = LoadingService.$loader($scope);

        $scope.$on('booking:moved', (event, purchase) => {
            this.purchase = purchase;
        });

        $scope.$on('booking:cancelReasonsLoaded', (event, cancelReasons) => {
            this.cancelReasons = cancelReasons;
        });

        $scope.$on('booking:moveReasonsLoaded', (event, moveReasons) => {
            this.moveReasons = moveReasons;
        });

        let checkCompanyForReasons = (companyId) => {
            let options = {root: $scope.bb.api_url};
            if($scope.bb.company.$has("reasons")) {
                this.companyHasReasons = true;
            }
        }

        let setPurchaseCompany = (company) => {

            $scope.bb.company_id = company.id;
            $scope.bb.company = new BBModel.Company(company);
            this.company = $scope.bb.company;
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

            if (this.fail_msg) {
                return AlertService.danger({msg: this.fail_msg});
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
                this.move_route = options.move_route;
            }
            if (options.move_all) {
                this.move_all = options.move_all;
            }
            if (options.fail_msg) {
                this.fail_msg = options.fail_msg;
            }


            // is there a purchase total already in scope?
            if ($scope.bb.total) {
                return load($scope.bb.total.long_id);
            } else if ($scope.bb.purchase) {
                this.purchase = $scope.bb.purchase;
                this.bookings = $scope.bb.purchase.bookings;
                if (this.purchase.confirm_messages) {
                    this.messages = this.purchase.confirm_messages;
                }
                return loader.setLoaded();
            } else {
                if (options.member_sso) {
                    return SSOService.memberLogin(options).then(login => load()
                        , (err) => {
                            loader.setLoaded();
                            return failMsg();
                        });
                } else {
                    return load();
                }
            }
        }.bind(this);

        let getPurchase = (params) => {

            let deferred = $q.defer();
            PurchaseService.query(params).then((purchase) => {
                    deferred.resolve(purchase);
                    purchase.$get('company').then(company => {
                        // using general options provider here to reduce api calls unless company reasons actually needed
                        if(GeneralOptions.useMoveCancelReasons) {
                            checkCompanyForReasons(company.id)
                        }
                        return setPurchaseCompany(company);
                        }
                    );
                    this.purchase = purchase;
                    $scope.bb.purchase = purchase;
                    return this.price = !(this.purchase.price === 0);
                }
                , (err) => { //get purchase
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

        let getBookings = (purchase) => {

            this.purchase.$getBookings().then((bookings) => {
                    this.bookings = bookings;

                    if (bookings[0]) {
                        bookings[0].$getCompany().then((company) => {
                            this.purchase.bookings[0].company = company;
                            $rootScope.$broadcast("purchase:loaded", company.id);
                            return company.$getAddress().then(address => this.purchase.bookings[0].company.address = address);
                        });
                    }

                    loader.setLoaded();
                    checkIfWaitlistBookings(bookings);

                    return Array.from(this.bookings).map((booking) =>
                        booking.$getAnswers().then(answers => booking.answers = answers));
                }
                , (err) => { //get booking
                    loader.setLoaded();
                    return failMsg();
                });

            if (purchase.$has('client')) {
                purchase.$get('client').then(client => {
                        return $scope.setClient(new BBModel.Client(client));
                    }
                );
            }
            return this.purchase.getConfirmMessages().then((messages) => {
                this.purchase.confirm_messages = messages;
                return this.messages = messages;
            });
        };

        let load = (id) => {

            loader.notLoaded();

            if (!id) {
                id = getPurchaseID();
            }

            if (!this.loaded && !!id) {
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

            return this.loaded = true;
        };


        var checkIfWaitlistBookings = bookings => this.waitlist_bookings = (Array.from(bookings).filter((booking) => (booking.on_waitlist && (booking.settings.sent_waitlist === 1))).map((booking) => booking));


        var loginRequired = () => {

            if (!$scope.bb.login_required) {
                return window.location = window.location.href + "&login=true";
            }
        };


        var getCompanyID = () => {

            let company_id;
            let matches = /^.*(?:\?|&)company_id=(.*?)(?:&|$)/.exec($location.absUrl());
            if (matches) {
                company_id = matches[1];
            }
            return company_id;
        };


        var getPurchaseID = () => {

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
        this.moveAll = function (route, options) {

            if (options == null) {
                options = {};
            }
            if (!route) {
                route = this.move_route;
            }
            loader.notLoaded();
            $scope.initWidget({company_id: this.bookings[0].company_id, no_route: true});
            return $timeout(() => {
                    return $rootScope.connection_started.then(() => {
                            let proms = [];
                            if (this.bookings.length === 1) {
                                $scope.bb.moving_booking = this.bookings[0];
                            } else {
                                $scope.bb.moving_booking = this.purchase;
                            }

                            if (_.every(_.map(this.bookings, b => b.event_id),
                                    event_id => event_id === this.bookings[0].event_id)) {
                                $scope.bb.moving_purchase = this.purchase;
                            }

                            this.quickEmptybasket();
                            for (let booking of Array.from(this.bookings)) {
                                let new_item = new BBModel.BasketItem(booking, $scope.bb);
                                new_item.setSrcBooking(booking);
                                new_item.ready = false;
                                new_item.move_done = false;
                                Array.prototype.push.apply(proms, new_item.promises);
                                $scope.bb.basket.addItem(new_item);
                            }
                            $scope.bb.sortStackedItems();

                            this.setBasketItem($scope.bb.basket.items[0]);
                            return $q.all(proms).then(() => {
                                    loader.setLoaded();
                                    return $scope.decideNextPage(route);
                                }
                                , (err) => {
                                    loader.setLoaded();
                                    return failMsg();
                                });
                        }
                        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
                }
            );
        };


        this.bookWaitlistItem = function (booking) {

            loader.notLoaded();

            let params = {
                purchase: this.purchase,
                booking
            };
            return PurchaseService.bookWaitlistItem(params).then((purchase) => {
                    this.purchase = purchase;
                    this.total = this.purchase;
                    $scope.bb.purchase = purchase;
                    return this.purchase.$getBookings().then((bookings) => {
                            this.bookings = bookings;
                            this.waitlist_bookings = ((() => {
                                let result = [];
                                for (booking of Array.from(this.bookings)) {
                                    if (booking.on_waitlist && (booking.settings.sent_waitlist === 1)) {
                                        result.push(booking);
                                    }
                                }
                                return result;
                            })());
                            if (this.purchase.$has('new_payment') && (this.purchase.due_now > 0)) {
                                this.make_payment = true;
                            }
                            return loader.setLoaded();
                        }
                        , (err) => {
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
        this.delete = (booking, cancelReasons) => {

            let modalInstance = $uibModal.open({
                templateUrl: $scope.getPartial("_cancel_modal"),
                controller: this.ModalDelete,
                resolve: {
                    booking() {
                        return booking;
                    },
                    cancelReasons() {
                        return cancelReasons
                    }
                }
            });

            return modalInstance.result.then((booking) => {
                let cancelReason = null;
                if (booking.cancelReason) {
                    ({cancelReason} = booking);
                }
                let data = {cancelReason};
                return booking.$del('self', {}, data).then(service => {
                        this.bookings = _.without(this.bookings, booking);
                        return $rootScope.$broadcast("booking:cancelled");
                    }
                );
            });
        };


        // delete all bookings assoicated to the purchase
        this.deleteAll = function () {

            let modalInstance = $uibModal.open({
                templateUrl: $scope.getPartial("_cancel_modal"),
                controller: ModalDeleteAll,
                resolve: {
                    purchase() {
                        return this.purchase;
                    }
                }
            });
            return modalInstance.result.then(purchase =>
                PurchaseService.deleteAll(purchase).then((purchase) => {
                    this.purchase = purchase;
                    this.bookings = [];
                    return $rootScope.$broadcast("booking:cancelled");
                })
            );
        };

        this.createBasketItem = function (booking) {

            let item = new BBModel.BasketItem(booking, $scope.bb);
            item.setSrcBooking(booking);
            return item;
        };


        this.checkAnswer = answer => (typeof answer.value === 'boolean') || (typeof answer.value === 'string') || (typeof answer.value === "number");


        this.changeAttendees = route => this.moveAll(route);


        // Simple modal controller for handling the 'delete' modal
        this.ModalDelete = ($scope, $rootScope, $uibModalInstance, booking, AlertService, cancelReasons) => {
            $scope.booking = booking;
            $scope.cancelReasons = cancelReasons;

            $scope.confirmDelete = () => {
                AlertService.clear();
                return $uibModalInstance.close(booking);
            };
            return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
        };

        // Simple modal controller for handling the 'delete all' modal
       this.ModalDeleteAll = ($scope, $rootScope, $uibModalInstance, purchase) => {
            $scope.purchase = purchase;

            $scope.confirmDelete = () => $uibModalInstance.close(purchase);

            return $scope.cancel = () => $uibModalInstance.dismiss("cancel");
        };

    };

})();
