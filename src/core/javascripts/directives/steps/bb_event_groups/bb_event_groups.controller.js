angular.module('BB.Controllers').controller('EventGroupList', function ($scope, $rootScope, $q, $attrs, ItemService, FormDataStoreService, ValidatorService, LoadingService) {

    FormDataStoreService.init('EventGroupList', $scope, [
        'event_group'
    ]);
    let loader = LoadingService.$loader($scope).notLoaded();

    $rootScope.connection_started.then(() => {
            if ($scope.bb.company) {
                return $scope.init($scope.bb.company);
            }
        }
        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


    $scope.init = function (comp) {
        if (!$scope.booking_item) {
            $scope.booking_item = $scope.bb.current_item;
        }
        let ppromise = comp.$getEventGroups();

        return ppromise.then(function (items) {
                // not all service lists need filtering. check for attribute first
                let item;
                let filterItems = $attrs.filterServices === 'false' ? false : true;

                if (filterItems) {
                    if ($scope.booking_item.service_ref && !$scope.show_all) {
                        items = items.filter(x => x.api_ref === $scope.booking_item.service_ref);
                    } else if ($scope.booking_item.category && !$scope.show_all) {
                        // if we've selected a category for the current item - limit the list
                        // of services to ones that are relevant
                        items = items.filter(x => x.$has('category') && (x.$href('category') === $scope.booking_item.category.self));
                    }
                }

                if ((items.length === 1) && !$scope.allowSinglePick) {
                    if (!$scope.selectItem(items[0], $scope.nextRoute)) {
                        setEventGroupItem(items);
                    } else {
                        $scope.skipThisStep();
                    }
                } else {
                    setEventGroupItem(items);
                }

                // if there's a default - pick it and move on
                let default_event_group = $scope.booking_item.defaultService();
                if (default_event_group) {
                    for (item of Array.from(items)) {
                        if (item.self === default_event_group.self) {
                            $scope.selectItem(item, $scope.nextRoute);
                        }
                    }
                }

                // if there's one selected - just select it
                if ($scope.booking_item.event_group) {
                    for (item of Array.from(items)) {
                        item.selected = false;
                        if (item.self === $scope.booking_item.event_group.self) {
                            $scope.event_group = item;
                            item.selected = true;
                            $scope.booking_item.setEventGroup($scope.event_group);
                        }
                    }
                }

                loader.setLoaded();

                if ($scope.booking_item.event_group || (!$scope.booking_item.person && !$scope.booking_item.resource)) {
                    // the "bookable services" are the event_group unless we've pre-selected something!
                    return $scope.bookable_services = $scope.items;
                }
            }
            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    };


    /***
     * @ngdoc method
     * @name setEventGroupItem
     * @methodOf BB.Directives:bbEventGroups
     * @description
     * Set event group item in accroding of items parameter
     *
     * @param {array} items Items of event group
     */
        // set the event_group item so the correct item is displayed in the dropdown menu.
        // without doing this the menu will default to 'please select'
    var setEventGroupItem = function (items) {
            $scope.items = items;
            if ($scope.event_group) {
                return _.each(items, function (item) {
                    if (item.id === $scope.event_group.id) {
                        return $scope.event_group = item;
                    }
                });
            }
        };

    /***
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbEventGroups
     * @description
     * Select an item from event group in according of item and route parameters
     *
     * @param {array} item The event group or BookableItem to select
     * @param {string=} route A specific route to load
     */
    $scope.selectItem = (item, route) => {
        if ($scope.$parent.$has_page_control) {
            $scope.event_group = item;
            return false;
        } else {
            $scope.booking_item.setEventGroup(item);
            $scope.decideNextPage(route);
            return true;
        }
    };

    $scope.$watch('event_group', (newval, oldval) => {
            if ($scope.event_group) {
                if (!$scope.booking_item.event_group || ($scope.booking_item.event_group.self !== $scope.event_group.self)) {
                    // only set and broadcast if it's changed
                    $scope.booking_item.setEventGroup($scope.event_group);
                    return $scope.broadcastItemUpdate();
                }
            }
        }
    );

    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbEventGroups
     * @description
     * Set this page section as ready
     */
    return $scope.setReady = () => {
        if ($scope.event_group) {
            $scope.booking_item.setEventGroup($scope.event_group);
            return true;
        } else {
            return false;
        }
    };
});
