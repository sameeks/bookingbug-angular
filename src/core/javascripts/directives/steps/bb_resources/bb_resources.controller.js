angular.module('BB.Controllers').controller('BBResourcesCtrl', BBResourcesCtrl);

function BBResourcesCtrl($scope, $rootScope, $attrs, $q, BBModel, ResourceModel, ValidatorService, LoadingService,
                         $localStorage) {
    'ngInject';

    let new_resource, resource;
    this.$scope = $scope;

    let loader = null;

    let restoreResource = () => {
        if ($scope.bb.current_item.resource != true && $scope.bb.current_item.resource != null) {
            $scope.decideNextPage();
        }
    };

    let storeResource = (resource) => {
        let store = $localStorage.getObject('bb');
        store.resourceId = resource.id;
        $localStorage.setObject('bb', store);
    };


    let init = function () {
        $scope.setReady = setReady.bind(this);
        $scope.selectItem = selectItem.bind(this);

        loader = LoadingService.$loader($scope).notLoaded();

        $rootScope.connection_started.then(connectionStartedSuccess.bind(this), connectionStartedFailure.bind(this));
        $scope.$watch('resource', resourceListener.bind(this));
        $scope.$on("currentItemUpdate", currentItemUpdateHandler.bind(this));

    };

    var connectionStartedSuccess = () => loadData();

    var connectionStartedFailure = err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong');

    var currentItemUpdateHandler = event => loadData();

    var loadData = () => {
        if (!$scope.booking_item) {
            $scope.booking_item = $scope.bb.current_item;
        }
        // do nothing if nothing has changed
        if ((!$scope.bb.steps || ($scope.bb.steps[0].page !== "resource_list")) && !$scope.options.resource_first) {
            if (!$scope.booking_item.service || ($scope.booking_item.service === $scope.change_watch_item)) {
                // if there's no service - we have to wait for one to be set - so we're done loading for now!
                if (!$scope.booking_item.service) {
                    loader.setLoaded();
                }
                return;
            }
        }

        $scope.change_watch_item = $scope.booking_item.service;
        loader.setLoaded();

        let rpromise = BBModel.Resource.$query($scope.bb.company);
        rpromise.then(resources => {
                if ($scope.booking_item.group) {  // check they're part of any currently selected group
                    resources = resources.filter(x => !x.group_id || (x.group_id === $scope.booking_item.group));
                }
                return $scope.all_resources = resources;
            }
        );

        let params = {
            company: $scope.bb.company,
            cItem: $scope.booking_item,
            wait: rpromise,
            item: 'resource'
        };
        return BBModel.BookableItem.$query(params).then(items => {
                let promises = [];
                if ($scope.booking_item.group) { // check they're part of any currently selected group
                    items = items.filter(x => !x.group_id || (x.group_id === $scope.booking_item.group));
                }

                for (var i of Array.from(items)) {
                    promises.push(i.promise);
                }

                return $q.all(promises).then(res => {
                        let resources = [];
                        for (i of Array.from(items)) {
                            resources.push(i.item);
                            if ($scope.booking_item && $scope.booking_item.resource && ($scope.booking_item.resource.id === i.item.id)) {
                                // set the resource unless the resource was automatically set
                                if ($scope.bb.current_item.settings.resource !== -1) {
                                    $scope.resource = i.item;
                                }
                            }
                        }
                        // if there's only one resource and single pick hasn't been enabled,
                        // automatically select the resource.
                        // OR if the resource has been passed into item_defaults and single pick hasn't been enabled,, skip to next step
                        if (resources.length === 1) {
                            resource = items[0];
                        }
                        if ($scope.bb.item_defaults.resource) {
                            ({resource} = $scope.bb.item_defaults);
                        }
                        if (resource && !$scope.selectItem(resource.item, $scope.nextRoute, {skip_step: true})) {
                            $scope.bookable_resources = resources;
                            $scope.bookable_items = items;
                        } else {
                            $scope.bookable_resources = resources;
                            $scope.bookable_items = items;
                        }

                        loader.setLoaded();

                        restoreResource();
                    }
                    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
            }
            , function (err) {
                if ((err !== "No service link found") || ((!$scope.bb.steps || ($scope.bb.steps[0].page !== 'resource_list')) && !$scope.options.resource_first)) {
                    loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
                } else {
                    loader.setLoaded();
                }
            });
    };

    /**
     * @ngdoc method
     * @name getItemFromResource
     * @methodOf BB.Directives:bbResources
     * @description
     * Get item from resource in according of resource parameter
     *
     * @param {object} resource The resource
     */
    let getItemFromResource = resource => {
        if (resource instanceof ResourceModel) {
            if ($scope.bookable_items) {
                for (let item of Array.from($scope.bookable_items)) {
                    if (item.item.self === resource.self) {
                        return item;
                    }
                }
            }
        }
        return resource;
    };

    /**
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbResources
     * @description
     * Select an item into the current booking journey and route on to the next page dpending on the current page control
     *
     * @param {array} item The Service or BookableItem to select
     * @param {string=} route A specific route to load
     * @param {string=} skip_step The skip_step has been set to false
     */
    var selectItem = (item, route, options) => {

        storeResource(item);

        if (options == null) {
            options = {};
        }

        if ($scope.$parent.$has_page_control) {
            $scope.resource = item;
            return false;
        } else {
            new_resource = getItemFromResource(item);
            _.each($scope.booking_items, item => item.setResource(new_resource));
            if (options.skip_step) {
                $scope.skipThisStep();
            }
            $scope.decideNextPage(route);
            return true;
        }
    };

    var resourceListener = (newval, oldval) => {
        if ($scope.resource && $scope.booking_item) {
            if (!$scope.booking_item.resource || ($scope.booking_item.resource.self !== $scope.resource.self)) {
                // only set and broadcast if it's changed
                new_resource = getItemFromResource($scope.resource);
                _.each($scope.booking_items, item => item.setResource(new_resource));
                return $scope.broadcastItemUpdate();
            }
        } else if (newval !== oldval) {
            _.each($scope.booking_items, item => item.setResource(null));
            return $scope.broadcastItemUpdate();
        }
    };

    /**
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbResources
     * @description
     * Set this page section as ready
     */
    var setReady = () => {
        if ($scope.resource) {
            new_resource = getItemFromResource($scope.resource);
            _.each($scope.booking_items, item => item.setResource(new_resource));
            return true;
        } else {
            _.each($scope.booking_items, item => item.setResource(null));
            return true;
        }
    };

    init();

}
