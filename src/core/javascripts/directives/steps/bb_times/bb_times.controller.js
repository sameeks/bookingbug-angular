// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('TimeList', function ($attrs, $element, $scope, $rootScope, $q, TimeService, AlertService, BBModel, DateTimeUtilitiesService, ValidatorService, LoadingService, ErrorService, $translate) {

    let loader = LoadingService.$loader($scope).notLoaded();

    if (!$scope.data_source) {
        $scope.data_source = $scope.bb.current_item;
    }
    $scope.options = $scope.$eval($attrs.bbTimes) || {};


    $rootScope.connection_started.then(function () {

            if ($scope.bb.current_item.defaults.date && !$scope.bb.current_item.date) {
                $scope.setDate($scope.bb.current_item.defaults.date);
            } else if ($scope.bb.current_item.date) {
                $scope.setDate($scope.bb.current_item.date.date);
            } else {
                $scope.setDate(moment());
            }

            return $scope.loadDay();
        }
        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


    /***
     * @ngdoc method
     * @name setDate
     * @methodOf BB.Directives:bbTimes
     * @description
     * Set the date the time list reprents
     *
     * @param {moment} the date to set the time list to use
     */
    $scope.setDate = date => {
        let day = new BBModel.Day({date, spaces: 1});
        $scope.selected_day = day;
        return $scope.selected_date = day.date;
    };


    /***
     * @ngdoc method
     * @name setDataSource
     * @methodOf BB.Directives:bbTimes
     * @description
     * Set data source model of time list
     *
     * @param {object} source The source
     */
    $scope.setDataSource = source => {
        return $scope.data_source = source;
    };

    /***
     * @ngdoc method
     * @name setItemLinkSource
     * @methodOf BB.Directives:bbTimes
     * @description
     * Set item link source model
     *
     * @param {object} source The source
     */
    $scope.setItemLinkSource = source => {
        return $scope.item_link_source = source;
    };


    $scope.$on('dateChanged', (event, newdate) => {
            $scope.setDate(newdate);
            return $scope.loadDay();
        }
    );


    // when the current item is updated, reload the time data
    $scope.$on("currentItemUpdate", event => $scope.loadDay({check_requested_slot: false}));


    /***
     * @ngdoc method
     * @name selectSlot
     * @methodOf BB.Directives:bbTimes
     * @description
     * Select the slot from time list in according of slot and route parameters
     *
     * @param {TimeSlot} slot The slot
     * @param {string} A specific route to load
     */
    $scope.selectSlot = (slot, day, route) => {

        if (slot && (slot.availability() > 0)) {

            // if this time cal was also for a specific item source (i.e.a person or resoure- make sure we've selected it)
            if ($scope.item_link_source) {
                $scope.data_source.setItem($scope.item_link_source);
            }

            if (slot.datetime) {
                $scope.setLastSelectedDate(slot.datetime);
                $scope.data_source.setDate({date: slot.datetime});
            } else if (day) {
                $scope.setLastSelectedDate(day.date);
                $scope.data_source.setDate(day);
            }

            $scope.data_source.setTime(slot);

            if ($scope.data_source.reserve_ready) {
                return $scope.addItemToBasket().then(() => {
                        return $scope.decideNextPage(route);
                    }
                );
            } else {
                return $scope.decideNextPage(route);
            }
        }
    };

    /***
     * @ngdoc method
     * @name highlightSlot
     * @methodOf BB.Directives:bbTimes
     * @description
     * The highlight slot from time list
     *
     * @param {TimeSlot} slot The slot
     */
    $scope.highlightSlot = (slot, day) => {
        if (day && slot && (slot.availability() > 0)) {
            if (slot.datetime) {
                $scope.setLastSelectedDate(slot.datetime);
                $scope.data_source.setDate({date: slot.datetime});
            } else if (day) {
                $scope.setLastSelectedDate(day.date);
                $scope.data_source.setDate(day);
            }

            $scope.data_source.setTime(slot);

            // tell any accordion groups to update
            return $scope.$broadcast('slotChanged');
        }
    };

    /***
     * @ngdoc method
     * @name status
     * @methodOf BB.Directives:bbTimes
     * @description
     * Check the status of the slot to see if it has been selected
     *
     * @param {date} slot The slot
     */
    // check the status of the slot to see if it has been selected
    $scope.status = function (slot) {
        if (!slot) {
            return;
        }
        let status = slot.status();
        return status;
    };


    /***
     * @ngdoc method
     * @name add
     * @methodOf BB.Directives:bbTimes
     * @description
     * Add unit of time to the selected day
     *
     * @param {date} type The type
     * @param {date} amount The amount
     */
    // add unit of time to the selected day
    $scope.add = (type, amount) => {

        // clear existing time
        delete $scope.bb.current_item.time;

        let new_date = moment($scope.selected_day.date).add(amount, type);
        $scope.setDate(new_date);
        return $scope.loadDay();
    };


    /***
     * @ngdoc method
     * @name subtract
     * @methodOf BB.Directives:bbTimes
     * @description
     * Subtract unit of time to the selected day
     *
     * @param {date} type The type
     * @param {date} amount The amount
     */
    // subtract unit of time to the selected day
    $scope.subtract = (type, amount) => {
        return $scope.add(type, -amount);
    };

    /***
     * @ngdoc method
     * @name loadDay
     * @methodOf BB.Directives:bbTimes
     * @description
     * Load day
     */
    $scope.loadDay = options => {
        if (!options) {
            options = {check_requested_slot: true};
        }
        if ($scope.data_source && ($scope.data_source.days_link || $scope.item_link_source) && $scope.selected_day) {

            $scope.notLoaded($scope);

            let pslots = TimeService.query({
                company: $scope.bb.company,
                cItem: $scope.data_source,
                item_link: $scope.item_link_source,
                date: $scope.selected_day.date,
                client: $scope.client,
                available: 1
            });

            pslots.finally(() => loader.setLoaded());
            return pslots.then(function (time_slots) {

                    $scope.slots = time_slots;
                    $scope.$broadcast('slotsUpdated', $scope.data_source, time_slots); // data_source is the BasketItem
                    // padding is used to ensure that a list of time slots is always padded out with a certain of values, if it's a partial set of results
                    if ($scope.add_padding && (time_slots.length > 0)) {
                        let dtimes = {};
                        for (let s of Array.from(time_slots)) {
                            dtimes[s.time] = 1;
                        }

                        for (let v = 0; v < $scope.add_padding.length; v++) {
                            let pad = $scope.add_padding[v];
                            if (!dtimes[pad]) {
                                time_slots.splice(v, 0, new BBModel.TimeSlot({time: pad, avail: 0}, time_slots[0].service));
                            }
                        }
                    }

                    if (options.check_requested_slot === true) {
                        return checkRequestedSlots(time_slots);
                    }
                }

                , function (err) {
                    if ((err.status === 404) && err.data && err.data.error && (err.data.error === "No bookable events found")) {
                        if ($scope.data_source && $scope.data_source.person) {
                            AlertService.warning(ErrorService.getError('NOT_BOOKABLE_PERSON'));
                            return $scope.setLoaded($scope);
                        } else if ($scope.data_source && $scope.data_source.resource) {
                            AlertService.warning(ErrorService.getError('NOT_BOOKABLE_RESOURCE'));
                            return $scope.setLoaded($scope);
                        } else {
                            return $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                        }
                    } else {
                        return $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                    }
                });

        } else {
            return loader.setLoaded();
        }
    };

    var checkRequestedSlots = function (time_slots) {
        if (!$scope.bb.item_defaults || !$scope.bb.item_defaults.time) {
            return;
        }

        let requested_slot = DateTimeUtilitiesService.checkDefaultTime($scope.selected_date, time_slots, $scope.data_source, $scope.bb.item_defaults);

        if ((requested_slot.slot === null) || (requested_slot.match === null)) {
            return $scope.availability_conflict = true;
        } else if (requested_slot.slot && (requested_slot.match === "full")) {
            $scope.skipThisStep();
            return $scope.selectSlot(requested_slot.slot, $scope.selected_day);
        } else if (requested_slot.slot && (requested_slot.match === "partial")) {
            return $scope.highlightSlot(requested_slot.slot, $scope.selected_day);
        }
    };

    /***
     * @ngdoc method
     * @name padTimes
     * @methodOf BB.Directives:bbTimes
     * @description
     * Pad Times in according of times parameter
     *
     * @param {date} times The times
     */
    $scope.padTimes = times => {
        return $scope.add_padding = times;
    };


    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbTimes
     * @description
     * Set this page section as ready
     */
    return $scope.setReady = function () {
        if (!$scope.data_source.time) {
            AlertService.clear();
            AlertService.add("danger", {msg: $translate.instant('PUBLIC_BOOKING.TIME.TIME_NOT_SELECTED_ALERT')});
            return false;
        } else {
            if ($scope.data_source.reserve_ready) {
                return $scope.addItemToBasket();
            } else {
                return true;
            }
        }
    };
});
