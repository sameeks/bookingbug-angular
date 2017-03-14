(function () {

    'use strict';

    angular.module('BB.Services').service('bbWidgetBasket', BBWidgetBasket);

    function BBWidgetBasket($q, halClient, BBModel, $localStorage, $sessionStorage, bbWidgetPage, bbWidgetStep, $uibModal,
                            bbWidgetUtilities, ErrorService, LoginService) {

        var $scope = null;
        var setScope = function ($s) {
            $scope = $s;
        };
        var guardScope = function () {
            if ($scope === null) {
                throw new Error('please provide scope');
            }
        };
        var deleteBasketItems = function (items) {
            guardScope();
            var item, j, len, results;
            results = [];
            for (j = 0, len = items.length; j < len; j++) {
                item = items[j];
                results.push(BBModel.Basket.$deleteItem(item, $scope.bb.company, {
                    bb: $scope.bb
                }).then(function (basket) {
                    return setBasket(basket);
                }));
            }
            return results;
        };
        var setBasketItem = function (item) {
            guardScope();
            return $scope.bb.current_item = item;
        };
        var clearBasketItem = function () {
            guardScope();
            var def;
            def = $q.defer();
            $scope.bb.current_item = new BBModel.BasketItem(null, $scope.bb);
            if ($scope.bb.default_setup_promises) {
                $q.all($scope.bb.default_setup_promises)["finally"](function () {
                    $scope.bb.current_item.setDefaults($scope.bb.item_defaults);
                    return $q.all($scope.bb.current_item.promises)["finally"](function () {
                        return def.resolve();
                    });
                });
            } else {
                $scope.bb.current_item.setDefaults({});
                def.resolve();
            }
            return def.promise;
        };
        var setBasket = function (basket) {
            guardScope();
            $scope.bb.basket = basket;
            $scope.basket = basket;
            $scope.bb.basket.company_id = $scope.bb.company_id;
            if ($scope.bb.stacked_items) {
                return $scope.bb.setStackedItems(basket.timeItems());
            }
        };
        var updateBasket = function () {
            guardScope();
            var add_defer, current_item_ref, params;
            current_item_ref = $scope.bb.current_item.ref;
            add_defer = $q.defer();
            params = {
                member_id: $scope.client.id,
                member: $scope.client,
                items: $scope.bb.basket.items,
                bb: $scope.bb
            };
            BBModel.Basket.$updateBasket($scope.bb.company, params).then(function (basket) {
                var current_item, item, j, len, ref;
                ref = basket.items;
                for (j = 0, len = ref.length; j < len; j++) {
                    item = ref[j];
                    item.storeDefaults($scope.bb.item_defaults);
                }
                halClient.clearCache("time_data");
                halClient.clearCache("events");
                basket.setSettings($scope.bb.basket.settings);
                setBasket(basket);
                current_item = _.find(basket.items, function (item) {
                    return item.ref === current_item_ref;
                });
                if (!current_item) {
                    current_item = _.last(basket.items);
                }
                $scope.bb.current_item = current_item;
                if (!$scope.bb.current_item) {
                    return clearBasketItem().then(function () {
                        return add_defer.resolve(basket);
                    });
                } else {
                    return add_defer.resolve(basket);
                }
            }, function (err) {
                var error_modal;
                add_defer.reject(err);
                if (err.status === 409) {
                    halClient.clearCache("time_data");
                    halClient.clearCache("events");
                    $scope.bb.current_item.person = null;
                    error_modal = $uibModal.open({
                        templateUrl: bbWidgetUtilities.getPartial('_error_modal'),
                        controller: function ($scope, $uibModalInstance) {
                            $scope.message = ErrorService.getError('ITEM_NO_LONGER_AVAILABLE').msg;
                            return $scope.ok = function () {
                                return $uibModalInstance.close();
                            };
                        }
                    });
                    return error_modal.result["finally"](function () {
                        if ($scope.bb.on_conflict) {
                            return $scope.$eval($scope.bb.on_conflict);
                        } else {
                            if ($scope.bb.nextSteps) {
                                if (!bbWidgetPage.setPageRoute($rootScope.Route.Date) && !bbWidgetPage.setPageRoute($rootScope.Route.Event)) {
                                    return bbWidgetStep.loadPreviousStep();
                                }
                            } else {
                                return bbWidgetPage.decideNextPage();
                            }
                        }
                    });
                }
            });
            return add_defer.promise;
        };
        var deleteBasketItem = function (item) {
            guardScope();
            return BBModel.Basket.$deleteItem(item, $scope.bb.company, {
                bb: $scope.bb
            }).then(function (basket) {
                return setBasket(basket);
            });
        };
        var emptyBasket = function () {
            guardScope();
            var defer;
            defer = $q.defer();
            if (!$scope.bb.basket.items || ($scope.bb.basket.items && $scope.bb.basket.items.length === 0)) {
                defer.resolve();
            } else {
                BBModel.Basket.$empty($scope.bb).then(function (basket) {
                    if ($scope.bb.current_item.id) {
                        delete $scope.bb.current_item.id;
                    }
                    setBasket(basket);
                    return defer.resolve();
                }, function (err) {
                    return defer.reject();
                });
            }
            return defer.promise;
        };
        var addItemToBasket = function () {
            guardScope();
            var add_defer;
            add_defer = $q.defer();
            if (!$scope.bb.current_item.submitted && !$scope.bb.moving_booking) {
                moveToBasket();
                $scope.bb.current_item.submitted = updateBasket();
                $scope.bb.current_item.submitted.then(function (basket) {
                    return add_defer.resolve(basket);
                }, function (err) {
                    if (err.status === 409) {
                        $scope.bb.current_item.person = null;
                        $scope.bb.current_item.resource = null;
                        $scope.bb.current_item.setTime(null);
                        if ($scope.bb.current_item.service) {
                            $scope.bb.current_item.setService($scope.bb.current_item.service);
                        }
                    }
                    $scope.bb.current_item.submitted = null;
                    return add_defer.reject(err);
                });
            } else if ($scope.bb.current_item.submitted) {
                return $scope.bb.current_item.submitted;
            } else {
                add_defer.resolve();
            }
            return add_defer.promise;
        };
        var moveToBasket = function () {
            guardScope();
            return $scope.bb.basket.addItem($scope.bb.current_item);
        };
        var quickEmptybasket = function (options) {
            guardScope();
            var def, preserve_stacked_items;
            preserve_stacked_items = options && options.preserve_stacked_items ? true : false;
            if (!preserve_stacked_items) {
                $scope.bb.stacked_items = [];
                setBasket(new BBModel.Basket(null, $scope.bb));
                return clearBasketItem();
            } else {
                $scope.bb.basket = new BBModel.Basket(null, $scope.bb);
                $scope.basket = $scope.bb.basket;
                $scope.bb.basket.company_id = $scope.bb.company_id;
                def = $q.defer();
                def.resolve();
                return def.promise;
            }
        };
        var restoreBasket = function () {
            guardScope();
            var restore_basket_defer;
            restore_basket_defer = $q.defer();
            quickEmptybasket().then(function () {
                var auth_token, href, params, status, uri;
                auth_token = $localStorage.getItem('auth_token') || $sessionStorage.getItem('auth_token');
                href = $scope.bb.api_url + '/api/v1/status{?company_id,affiliate_id,clear_baskets,clear_member}';
                params = {
                    company_id: $scope.bb.company_id,
                    affiliate_id: $scope.bb.affiliate_id,
                    clear_baskets: $scope.bb.clear_basket ? '1' : null,
                    clear_member: $scope.bb.clear_member ? '1' : null
                };
                uri = new UriTemplate(href).fillFromObject(params);
                status = halClient.$get(uri, {
                    "auth_token": auth_token,
                    "no_cache": true
                });
                return status.then((function (_this) {
                    return function (res) {
                        if (res.$has('client')) {
                            res.$get('client').then(function (client) {
                                if (!$scope.client || ($scope.client && !$scope.client.valid())) {
                                    return $scope.client = new BBModel.Client(client);
                                }
                            });
                        }
                        if (res.$has('member')) {
                            res.$get('member').then(function (member) {
                                if (member.client_type !== 'Contact') {
                                    member = LoginService.setLogin(member);
                                    return $scope.setClient(member);
                                }
                            });
                        }
                        if ($scope.bb.clear_basket) {
                            return restore_basket_defer.resolve();
                        } else {
                            if (res.$has('baskets')) {
                                return res.$get('baskets').then(function (baskets) {
                                    var basket;
                                    basket = _.find(baskets, function (b) {
                                        return parseInt(b.company_id) === $scope.bb.company_id;
                                    });
                                    if (basket) {
                                        basket = new BBModel.Basket(basket, $scope.bb);
                                        return basket.$get('items').then(function (items) {
                                            var i, j, len, promises;
                                            items = (function () {
                                                var j, len, results;
                                                results = [];
                                                for (j = 0, len = items.length; j < len; j++) {
                                                    i = items[j];
                                                    results.push(new BBModel.BasketItem(i));
                                                }
                                                return results;
                                            })();
                                            for (j = 0, len = items.length; j < len; j++) {
                                                i = items[j];
                                                basket.addItem(i);
                                            }
                                            setBasket(basket);
                                            promises = [].concat.apply([], (function () {
                                                var l, len1, results;
                                                results = [];
                                                for (l = 0, len1 = items.length; l < len1; l++) {
                                                    i = items[l];
                                                    results.push(i.promises);
                                                }
                                                return results;
                                            })());
                                            return $q.all(promises).then(function () {
                                                if (basket.items.length > 0) {
                                                    $scope.bb.current_item = basket.items[0];
                                                }
                                                return restore_basket_defer.resolve();
                                            });
                                        });
                                    } else {
                                        return restore_basket_defer.resolve();
                                    }
                                });
                            } else {
                                return restore_basket_defer.resolve();
                            }
                        }
                    };
                })(this), function (err) {
                    return restore_basket_defer.resolve();
                });
            });
            return restore_basket_defer.promise;
        };
        var setUsingBasket = function (usingBasket) {
            return $scope.bb.usingBasket = usingBasket;
        };
        var showCheckout = function () {
            guardScope();
            return $scope.bb.current_item.ready;
        };
        var setReadyToCheckout = function (ready) {
            guardScope();
            return $scope.bb.confirmCheckout = ready;
        };

        let createBasketFromBookings = function (bookings, totalDefer) {
            let booking, i, len, newItem;
            let promises = [];

            for (i = 0, len = bookings.length; i < len; i++) {
                booking = bookings[i];
                newItem = new BBModel.BasketItem(booking, $scope.bb);
                newItem.setSrcBooking(booking, $scope.bb);
                Array.prototype.push.apply(promises, newItem.promises);
                $scope.bb.basket.addItem(newItem);
            }

            if (bookings.length === 1) {
                $scope.bb.current_item = $scope.bb.basket.items[0];
                $scope.bb.current_item.setDefaults({});
            } else {
                if (bookings.length > 1) {
                    $scope.bb.setStackedItems($scope.bb.basket.items);
                }
            }

            $scope.bb.movingBooking = bookings;

            return $q.all(promises).then(() => {
                return totalDefer.resolve();
            }, (err) =>  {
                return totalDefer.reject(err);
            });
        }

        return {
            setScope: setScope,
            deleteBasketItems: deleteBasketItems,
            setBasketItem: setBasketItem,
            clearBasketItem: clearBasketItem,
            setBasket: setBasket,
            updateBasket: updateBasket,
            deleteBasketItem: deleteBasketItem,
            emptyBasket: emptyBasket,
            addItemToBasket: addItemToBasket,
            moveToBasket: moveToBasket,
            quickEmptybasket: quickEmptybasket,
            restoreBasket: restoreBasket,
            setUsingBasket: setUsingBasket,
            showCheckout: showCheckout,
            setReadyToCheckout: setReadyToCheckout,
            createBasketFromBookings: createBasketFromBookings
        };
    }

})();
