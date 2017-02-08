(function () {
    'use strict'

    angular.module('BB.Controllers').controller('BBServicesCtrl', BBServicesCtrl);

    function BBServicesCtrl($scope, $rootScope, $q, $attrs, $uibModal, BBModel, FormDataStoreService, ValidatorService, ErrorService, $filter, LoadingService) {
        'ngInject';

        this.$scope = $scope;

        FormDataStoreService.init('ServiceList', $scope, ['service']);

        var loader = LoadingService.$loader($scope).notLoaded();
        $scope.validator = ValidatorService;
        $scope.filters = {
            category_name: null,
            service_name: null,
            price: {
                min: 0,
                max: 100
            },
            custom_array_value: null
        };
        $scope.show_custom_array = false;
        $scope.options = $scope.$eval($attrs.bbServices) || {};
        if ($attrs.bbItem) {
            $scope.booking_item = $scope.$eval($attrs.bbItem);
        }
        if ($attrs.bbShowAll || $scope.options.show_all) {
            $scope.show_all = true;
        }
        if ($scope.options.allow_single_pick) {
            $scope.allowSinglePick = true;
        }
        if ($scope.options.hide_disabled) {
            $scope.hide_disabled = true;
        }
        $scope.price_options = {
            min: 0,
            max: 100
        };
        $rootScope.connection_started.then((function (_this) {
            return function () {
                if ($scope.bb.company) {
                    return $scope.init($scope.bb.company);
                }
            };
        })(this), function (err) {
            return loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
        });
        $scope.init = function (comp) {
            var all_loaded, ispromise, ppromise;
            $scope.booking_item || ($scope.booking_item = $scope.bb.current_item);
            if ($scope.bb.company.$has('named_categories')) {
                BBModel.Category.$query($scope.bb.company).then((function (_this) {
                    return function (items) {
                        return $scope.all_categories = items;
                    };
                })(this), function (err) {
                    return $scope.all_categories = [];
                });
            } else {
                $scope.all_categories = [];
            }
            if ($scope.service && $scope.service.company_id !== $scope.bb.company.id) {
                $scope.service = null;
            }
            ppromise = comp.$getServices();
            all_loaded = [ppromise];
            ppromise.then((function (_this) {
                return function (items) {
                    var filterItems, item, j, k, len, len1;
                    if ($scope.options.hide_disabled) {
                        items = items.filter(function (x) {
                            return !x.disabled && !x.deleted;
                        });
                    }
                    filterItems = $attrs.filterServices === 'false' ? false : true;
                    if (filterItems) {
                        if ($scope.booking_item.service_ref && !$scope.options.show_all) {
                            items = items.filter(function (x) {
                                return x.api_ref === $scope.booking_item.service_ref;
                            });
                        } else if ($scope.booking_item.category && !$scope.options.show_all) {
                            items = items.filter(function (x) {
                                return x.$has('category') && x.$href('category') === $scope.booking_item.category.self;
                            });
                        }
                    }
                    if (!$scope.options.show_event_groups) {
                        items = items.filter(function (x) {
                            return !x.is_event_group;
                        });
                    }
                    if (items.length === 1 && !$scope.options.allow_single_pick) {
                        if (!$scope.selectItem(items[0], $scope.nextRoute, {
                                skip_step: true
                            })) {
                            setServiceItem(items);
                        }
                    } else {
                        setServiceItem(items);
                    }
                    if ($scope.booking_item.defaultService()) {
                        for (j = 0, len = items.length; j < len; j++) {
                            item = items[j];
                            if (item.self === $scope.booking_item.defaultService().self || (item.name === $scope.booking_item.defaultService().name && !item.deleted)) {
                                $scope.selectItem(item, $scope.nextRoute, {
                                    skip_step: true
                                });
                            }
                        }
                    }
                    if ($scope.booking_item.service) {
                        for (k = 0, len1 = items.length; k < len1; k++) {
                            item = items[k];
                            item.selected = false;
                            if (item.self === $scope.booking_item.service.self) {
                                $scope.service = item;
                                item.selected = true;
                                $scope.booking_item.setService($scope.service);
                            }
                        }
                    }
                    if ($scope.booking_item.service || !(($scope.booking_item.person && !$scope.booking_item.anyPerson()) || ($scope.booking_item.resource && !$scope.booking_item.anyResource()))) {
                        items = setServicesDisplayName(items);
                        return $scope.bookable_services = items;
                    }
                };
            })(this), function (err) {
                return loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
            });
            if (($scope.booking_item.person && !$scope.booking_item.anyPerson()) || ($scope.booking_item.resource && !$scope.booking_item.anyResource())) {
                ispromise = BBModel.BookableItem.$query({
                    company: $scope.bb.company,
                    cItem: $scope.booking_item,
                    wait: ppromise,
                    item: 'service'
                });
                all_loaded.push(ispromise);
                ispromise.then(
                    function (items) {
                        var i, services;
                        if ($scope.booking_item.service_ref) {
                            items = items.filter(function (x) {
                                return x.api_ref === $scope.booking_item.service_ref;
                            });
                        }
                        if ($scope.booking_item.group) {
                            items = items.filter(function (x) {
                                return !x.group_id || x.group_id === $scope.booking_item.group;
                            });
                        }
                        if ($scope.options.hide_disabled) {
                            items = items.filter(function (x) {
                                return (x.item == null) || (!x.item.disabled && !x.item.deleted);
                            });
                        }
                        services = (function () {
                            var j, len, results;
                            results = [];
                            for (j = 0, len = items.length; j < len; j++) {
                                i = items[j];
                                if (i.item != null) {
                                    results.push(i.item);
                                }
                            }
                            return results;
                        })();
                        services = setServicesDisplayName(services);
                        $scope.bookable_services = services;
                        $scope.bookable_items = items;
                        if (services.length === 1 && !$scope.options.allow_single_pick) {
                            if (!$scope.selectItem(services[0], $scope.nextRoute, {
                                    skip_step: true
                                })) {
                                return setServiceItem(services);
                            }
                        } else {
                            return setServiceItem(services);
                        }
                    },
                    function (err) {
                        return loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                    }
                );
            }
            return $q.all(all_loaded).then(function () {
                return loader.setLoaded();
            });
        };
        function setServicesDisplayName(items) {
            var item, j, len;
            for (j = 0, len = items.length; j < len; j++) {
                item = items[j];
                if (item.listed_durations && item.listed_durations.length === 1) {
                    item.display_name = item.name + ' - ' + $filter('time_period')(item.duration);
                } else {
                    item.display_name = item.name;
                }
            }
            return items;
        }

        function setServiceItem(items) {
            $scope.items = items;
            $scope.filtered_items = $scope.items;
            if ($scope.service) {
                return _.each(items, function (item) {
                    if (item.id === $scope.service.id) {
                        return $scope.service = item;
                    }
                });
            }
        }

        /***
         * @ngdoc method
         * @name selectItem
         * @methodOf BB.Directives:bbServices
         * @description
         * Select an item into the current booking journey and route on to the next page dpending on the current page control
         *
         * @param {object} item The Service or BookableItem to select
         * @param {string=} route A specific route to load
         */
        $scope.selectItem = function (item, route, options) {
            if (options == null) {
                options = {};
            }
            if ($scope.routed) {
                return true;
            }
            if ($scope.$parent.$has_page_control) {
                $scope.service = item;
                return false;
            } else if (item.is_event_group) {
                $scope.booking_item.setEventGroup(item);
                if (options.skip_step) {
                    $scope.skipThisStep();
                }
                $scope.decideNextPage(route);
                return $scope.routed = true;
            } else {
                $scope.booking_item.setService(item);
                $scope.bb.selected_service = $scope.booking_item.service;
                if (options.skip_step) {
                    $scope.skipThisStep();
                }
                $scope.decideNextPage(route);
                $scope.routed = true;
                return true;
            }
        };

        $scope.$watch('service', function (newval, oldval) {
            if ($scope.service && $scope.booking_item) {
                if (!$scope.booking_item.service || $scope.booking_item.service.self !== $scope.service.self) {
                    $scope.booking_item.setService($scope.service);
                    $scope.broadcastItemUpdate();
                    return $scope.bb.selected_service = $scope.service;
                }
            }
        });

        /***
         * @ngdoc method
         * @name setReady
         * @methodOf BB.Directives:bbServices
         * @description
         * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
         */
        $scope.setReady = function () {
            if ($scope.service) {
                $scope.booking_item.setService($scope.service);
                return true;
            } else if ($scope.bb.stacked_items && $scope.bb.stacked_items.length > 0) {
                return true;
            } else {
                return false;
            }
        };

        /***
         * @ngdoc method
         * @name errorModal
         * @methodOf BB.Directives:bbServices
         * @description
         * Display error message in modal
         */
        $scope.errorModal = function () {
            var error_modal;
            return error_modal = $uibModal.open({
                templateUrl: $scope.getPartial('_error_modal'),
                controller: function ($scope, $uibModalInstance) {
                    $scope.message = ErrorService.getError('GENERIC').msg;
                    return $scope.ok = function () {
                        return $uibModalInstance.close();
                    };
                }
            });
        };

        /***
         * @ngdoc method
         * @name filterFunction
         * @methodOf BB.Directives:bbServices
         * @description
         * Filter service
         */
        $scope.filterFunction = function (service) {
            if (!service) {
                return false;
            }
            $scope.service_array = [];
            $scope.custom_array = function (match) {
                var item, j, len, ref;
                if (!match) {
                    return false;
                }
                if ($scope.options.custom_filter) {
                    match = match.toLowerCase();
                    ref = service.extra[$scope.options.custom_filter];
                    for (j = 0, len = ref.length; j < len; j++) {
                        item = ref[j];
                        item = item.toLowerCase();
                        if (item === match) {
                            $scope.show_custom_array = true;
                            return true;
                        }
                    }
                    return false;
                }
            };
            $scope.service_name_include = function (match) {
                var item;
                if (!match) {
                    return false;
                }
                if (match) {
                    match = match.toLowerCase();
                    item = service.name.toLowerCase();
                    if (item.includes(match)) {
                        return true;
                    } else {
                        return false;
                    }
                }
            };
            return (!$scope.filters.category_name || service.category_id === $scope.filters.category_name.id) && (!$scope.filters.service_name || $scope.service_name_include($scope.filters.service_name)) && (!$scope.filters.custom_array_value || $scope.custom_array($scope.filters.custom_array_value)) && (!service.price || (service.price >= $scope.filters.price.min * 100 && service.price <= $scope.filters.price.max * 100));
        };

        /***
         * @ngdoc method
         * @name resetFilters
         * @methodOf BB.Directives:bbServices
         * @description
         * Clear the filters
         */
        $scope.resetFilters = function () {
            if ($scope.options.clear_results) {
                $scope.show_custom_array = false;
            }
            $scope.filters.category_name = null;
            $scope.filters.service_name = null;
            $scope.filters.price.min = 0;
            $scope.filters.price.max = 100;
            $scope.filters.custom_array_value = null;
            return $scope.filterChanged();
        };

        /***
         * @ngdoc method
         * @name filterChanged
         * @methodOf BB.Directives:bbServices
         * @description
         * Filter changed
         */
        $scope.filterChanged = function () {
            return $scope.filtered_items = $filter('filter')($scope.items, $scope.filterFunction);
        };
    }


})();
