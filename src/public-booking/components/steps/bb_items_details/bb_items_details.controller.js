angular.module('BB.Controllers').controller('ItemDetails', function ($scope, $attrs, $rootScope, PurchaseBookingService, AlertService, BBModel, FormDataStoreService, ValidatorService, $uibModal, $document, $translate, $filter, GeneralOptions, PurchaseService, LoadingService) {

    let loader = LoadingService.$loader($scope);

    $scope.suppress_basket_update = ($attrs.bbSuppressBasketUpdate != null);
    $scope.item_details_id = $scope.$eval($attrs.bbSuppressBasketUpdate);

    // if instructed to suppress basket updates (i.e. when the directive is invoked multiple times
    // on the same page), create a form store for each instance of the directive
    if ($scope.suppress_basket_update) {
        FormDataStoreService.init((`ItemDetails${$scope.item_details_id}`), $scope, ['item_details']);
    } else {
        FormDataStoreService.init('ItemDetails', $scope, ['item_details']);
    }

    // populate object with values stored in the question store. addAnswersByName()
    // is good for populating a single object. for dynamic question/answers see
    // addDynamicAnswersByName()
    BBModel.Question.$addAnswersByName($scope.client, [
        'first_name',
        'last_name',
        'email',
        'mobile'
    ]);

    console.warn('Deprecation warning: validator.validateForm() will be removed from bbItemDetails in an upcoming major release, please update your template to use bbForm and submitForm() instead. See https://github.com/bookingbug/bookingbug-angular/issues/638');
    $scope.validator = ValidatorService;

    let confirming = false;


    $rootScope.connection_started.then(function () {
            if (!confirming) {
                return $scope.loadItem($scope.bb.current_item);
            }
        }
        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

    /***
     * @ngdoc method
     * @name loadItem
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Load item in according of item parameter
     *
     * @param {array} item The item loaded
     */
    $scope.loadItem = function (item) {

        loader.notLoaded();

        confirming = true;
        $scope.item = item;
        if ($scope.bb.private_note) {
            $scope.item.private_note = $scope.bb.private_note;
        }
        $scope.product = item.product;

        if ($scope.item.item_details) {
            setItemDetails($scope.item.item_details);
            // this will add any values in the querystring
            BBModel.Question.$addDynamicAnswersByName($scope.item_details.questions);
            if ($scope.bb.item_defaults.answers) {
                BBModel.Question.$addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers);
            }
            $scope.recalc_price();
            loader.setLoaded();
            return $scope.$emit("item_details:loaded", $scope.item_details);

        } else {

            let params = {company: $scope.bb.company, cItem: $scope.item};
            return BBModel.ItemDetails.$query(params).then(function (details) {
                    if (details) {
                        setItemDetails(details);
                        $scope.item.item_details = $scope.item_details;
                        BBModel.Question.$addDynamicAnswersByName($scope.item_details.questions);
                        if ($scope.bb.item_defaults.answers) {
                            BBModel.Question.$addAnswersFromDefaults($scope.item_details.questions, $scope.bb.item_defaults.answers);
                        }
                        $scope.recalc_price();
                        $scope.$emit("item_details:loaded", $scope.item_details);
                    }
                    return loader.setLoaded();
                }

                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
        }
    };


    /***
     * @ngdoc method
     * @name setItemDetails
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Set item details in according of details parameter
     *
     * @param {array} details The details parameter
     */
        // compare the questions stored in the data store to the new questions and if
        // any of them match then copy the answer value. we're doing it like this as
        // the amount of questions can change based on selections made earlier in the
        // journey, so we can't just store the questions.
    var setItemDetails = function (details) {
            if ($scope.item && $scope.item.defaults) {
                _.each(details.questions, function (item) {
                    let n = `q_${item.name}`;
                    if ($scope.item.defaults[n]) {
                        return item.answer = $scope.item.defaults[n];
                    }
                });
            }

            if ($scope.hasOwnProperty('item_details')) {
                let oldQuestions = $scope.item_details.questions;

                _.each(details.questions, function (item) {
                    let search = _.findWhere(oldQuestions, {name: item.name});
                    if (search) {
                        return item.answer = search.answer;
                    }
                });
            }
            return $scope.item_details = details;
        };

    // TODO document listener
    $scope.$on('currentItemUpdate', function (event) {
        if ($scope.item_from_param) {
            return $scope.loadItem($scope.item_from_param);
        } else {
            return $scope.loadItem($scope.bb.current_item);
        }
    });

    /***
     * @ngdoc method
     * @name recalc_price
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Recalculate item price in function of quantity
     */
    $scope.recalc_price = function () {
        let qprice = $scope.item_details.questionPrice($scope.item.getQty());
        let bprice = $scope.item.base_price;
        if (!bprice) {
            bprice = $scope.item.price;
        }

        $scope.item.setPrice(qprice + bprice);

        // set the asked_questions bool in the BasketItem model so that its getPostData method sends question data to the API
        return $scope.item.setAskedQuestions();
    };

    /***
     * @ngdoc method
     * @name confirm
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Confirm the question
     *
     * @param {object} form The form where question are introduced
     * @param {string=} route A specific route to load
     */
    $scope.confirm = function (form, route) {
        if (!ValidatorService.validateForm(form)) {
            return;
        }
        // we need to validate the question information has been correctly entered here
        if ($scope.bb.moving_booking) {
            return $scope.confirm_move(form, route);
        }

        $scope.item.setAskedQuestions();

        if ($scope.$parent.$has_page_control) {
            return true;
        }


        if ($scope.item.ready) {
            loader.notLoaded();
            return $scope.addItemToBasket().then(function () {
                    loader.setLoaded();
                    return $scope.decideNextPage(route);
                }
                , err => loader.setLoaded());
        } else {
            return $scope.decideNextPage(route);
        }
    };

    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
     */
    $scope.setReady = () => {

        $scope.item.setAskedQuestions();

        if ($scope.item.ready && !$scope.suppress_basket_update) {
            return $scope.addItemToBasket();
        } else {
            return true;
        }
    };

    /***
     * @ngdoc method
     * @name confirm_move
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Confirm move question information has been correctly entered here
     *
     * @param {string=} route A specific route to load
     */
    $scope.confirm_move = function (route) {

        confirming = true;
        if (!$scope.item) {
            $scope.item = $scope.bb.current_item;
        }
        $scope.item.moved_booking = false;
        // we need to validate the question information has been correctly entered here
        $scope.item.setAskedQuestions();
        if ($scope.item.ready) {
            loader.notLoaded();
            if ($scope.bb.moving_purchase) {
                let params = {
                    purchase: $scope.bb.moving_purchase,
                    bookings: $scope.bb.basket.items
                };
                if ($scope.bb.current_item.move_reason) {
                    params.move_reason = $scope.bb.current_item.move_reason;
                }
                return PurchaseService.update(params).then(function (purchase) {
                        $scope.bb.purchase = purchase;
                        return $scope.bb.purchase.$getBookings().then(function (bookings) {
                            $scope.purchase = purchase;
                            loader.setLoaded();
                            $scope.item.move_done = true;
                            $scope.item.moved_booking = true;
                            $rootScope.$broadcast("booking:moved");
                            $scope.decideNextPage(route);
                            return $scope.showMoveMessage(bookings[0].datetime);
                        });
                    }


                    , function (err) {
                        loader.setLoaded();
                        return AlertService.add("danger", {msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_FAIL_ALERT')});
                    });
            } else {
                if ($scope.bb.current_item.move_reason) {
                    $scope.item.move_reason = $scope.bb.current_item.move_reason;
                }
                return PurchaseBookingService.update($scope.item).then(function (booking) {
                        let b = new BBModel.Purchase.Booking(booking);

                        if ($scope.bb.purchase) {
                            for (let _i = 0; _i < $scope.bb.purchase.bookings.length; _i++) {
                                let oldb = $scope.bb.purchase.bookings[_i];
                                if (oldb.id === b.id) {
                                    $scope.bb.purchase.bookings[_i] = b;
                                }
                            }
                        }

                        loader.setLoaded();
                        $scope.bb.moved_booking = booking;
                        $scope.item.move_done = true;
                        $rootScope.$broadcast("booking:moved");
                        $scope.decideNextPage(route);
                        return $scope.showMoveMessage(b.datetime);
                    }
                    , err => {
                        loader.setLoaded();
                        return AlertService.add("danger", {msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_FAIL_ALERT')});
                    }
                );
            }
        } else {
            return $scope.decideNextPage(route);
        }
    };

    $scope.showMoveMessage = datetime => AlertService.add("info", {msg: $translate.instant('PUBLIC_BOOKING.ITEM_DETAILS.MOVE_BOOKING_SUCCESS_ALERT', {datetime})});


    /***
     * @ngdoc method
     * @name openTermsAndConditions
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Display terms and conditions view
     */
    $scope.openTermsAndConditions = function () {
        return $uibModal.open({
            templateUrl: $scope.getPartial("terms_and_conditions"),
            scope: $scope
        });
    };

    /***
     * @ngdoc method
     * @name getQuestion
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Get question by id
     *
     * @param {integer} id The id of the question
     */
    $scope.getQuestion = function (id) {
        for (let question of Array.from($scope.item_details.questions)) {
            if (question.id === id) {
                return question;
            }
        }

        return null;
    };

    /***
     * @ngdoc method
     * @name updateItem
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Update item
     */
    $scope.updateItem = function () {
        $scope.item.setAskedQuestions();
        if ($scope.item.ready) {
            loader.notLoaded();

            return PurchaseBookingService.update($scope.item).then(function (booking) {

                    let b = new BBModel.Purchase.Booking(booking);
                    if ($scope.bookings) {
                        for (let _i = 0; _i < $scope.bookings.length; _i++) {
                            let oldb = $scope.bookings[_i];
                            if (oldb.id === b.id) {
                                $scope.bookings[_i] = b;
                            }
                        }
                    }

                    $scope.purchase.bookings = $scope.bookings;
                    $scope.item_details_updated = true;
                    return loader.setLoaded();
                }

                , err => {
                    return loader.setLoaded();
                }
            );
        }
    };

    /***
     * @ngdoc method
     * @name editItem
     * @methodOf BB.Directives:bbItemDetails
     * @description
     * Edit item
     */
    return $scope.editItem = () => $scope.item_details_updated = false;
});
