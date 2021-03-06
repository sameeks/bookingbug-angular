angular.module('BB.Controllers').controller('TimeRangeListStackedController', function ($scope, $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel,
                                                                                        FormDataStoreService, PersonService, PurchaseService, DateTimeUtilitiesService,
                                                                                        LoadingService) {

    FormDataStoreService.init('TimeRangeListStacked', $scope, [
        'selected_slot',
        'original_start_date',
        'start_at_week_start'
    ]);

    // show the loading icon
    let loader = LoadingService.$loader($scope).notLoaded();
    $scope.available_times = 0;

    $rootScope.connection_started.then(function () {

        // read initialisation attributes
        let selected_day;
        $scope.options = $scope.$eval($attrs.bbTimeRangeStacked) || {};

        if (!$scope.time_range_length) {
            if ($attrs.bbTimeRangeLength != null) {
                $scope.time_range_length = $scope.$eval($attrs.bbTimeRangeLength);
            } else if ($scope.options && $scope.options.time_range_length) {
                $scope.time_range_length = $scope.options.time_range_length;
            } else {
                $scope.time_range_length = 7;
            }
        }

        if (($attrs.bbDayOfWeek != null) || ($scope.options && $scope.options.day_of_week)) {
            $scope.day_of_week = ($attrs.bbDayOfWeek != null) ? $scope.$eval($attrs.bbDayOfWeek) : $scope.options.day_of_week;
        }

        if (($attrs.bbSelectedDay != null) || ($scope.options && $scope.options.selected_day)) {
            selected_day = ($attrs.bbSelectedDay != null) ? moment($scope.$eval($attrs.bbSelectedDay)) : moment($scope.options.selected_day);
            if (moment.isMoment(selected_day)) {
                $scope.selected_day = selected_day;
            }
        }

        $scope.options.ignore_min_advance_datetime = $scope.options.ignore_min_advance_datetime ? true : false;

        setMinMaxDate();

        // initialise the time range
        // last selected day is set (i.e, a user has already selected a date)
        if (!$scope.start_date && $scope.last_selected_date) {
            if ($scope.original_start_date) {
                let diff = $scope.last_selected_date.diff($scope.original_start_date, 'days');
                diff = diff % $scope.time_range_length;
                diff = diff === 0 ? diff : diff + 1;
                let start_date = $scope.last_selected_date.clone().subtract(diff, 'days');
                setTimeRange($scope.last_selected_date, start_date);
            } else {
                setTimeRange($scope.last_selected_date);
            }
            // the current item already has a date
        } else if ($scope.bb.stacked_items[0].date) {
            setTimeRange($scope.bb.stacked_items[0].date.date);
            // selected day has been provided, use this to set the time
        } else if ($scope.selected_day) {
            $scope.original_start_date = $scope.original_start_date || moment($scope.selected_day);
            setTimeRange($scope.selected_day);
            // set the time range as today
        } else {
            $scope.start_at_week_start = true;
            setTimeRange(moment());
        }

        return $scope.loadData();
    });


    /***
     * @ngdoc method
     * @name setTimeRange
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Set time range in according of selected_date
     *
     * @param {date} selected_date The selected date from multi time range list
     * @param {date} start_date The start date of range list
     */
    var setTimeRange = function (selected_date, start_date) {
        if (start_date) {
            $scope.start_date = start_date;
        } else if ($scope.day_of_week) {
            $scope.start_date = selected_date.clone().day($scope.day_of_week);
        } else if ($scope.start_at_week_start) {
            $scope.start_date = selected_date.clone().startOf('week');
        } else {
            $scope.start_date = selected_date.clone();
        }

        $scope.selected_day = selected_date;
        // convert selected day to JS date object for date picker, it needs
        // to be saved as a variable as functions cannot be passed into the
        // AngluarUI date picker
        $scope.selected_date = $scope.selected_day.toDate();

        isSubtractValid();

        isAddValid();
    };


    /***
     * @ngdoc method
     * @name setMinMaxDate
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Set min, max date and time range based on min/max advance datetime of the selected service
     *
     */
    var setMinMaxDate = function () {

        let current_item = $scope.bb.current_item;
        // has a service been selected?
        if (current_item.service && !$scope.options.ignore_min_advance_datetime) {

            $scope.min_date = current_item.service.min_advance_datetime;
            $scope.max_date = current_item.service.max_advance_datetime;

            // date helpers for use by datepicker-popup
            $scope.minDateJs = $scope.min_date.toDate();
            $scope.maxDateJs = $scope.max_date.toDate();

            //calculate duration of max date from today
            if (!$scope.maxDateDuration) {
                let maxDate = $scope.max_date.clone();
                let today = moment().clone();
                let difference = maxDate.startOf('day').diff(today.startOf('day'), 'days', true);
                let maxDateDuration = moment.duration(difference, 'days').humanize();
                // store it on scope in a form to support translations
                $scope.maxDateDurationObj = {maxDateDuration: maxDateDuration};
            }

            // if the selected day is before the services min_advance_datetime, adjust the time range
            if ($scope.selected_day && $scope.selected_day.isBefore(current_item.service.min_advance_datetime, 'day') && !$scope.isAdmin()) {
                setTimeRange(current_item.service.min_advance_datetime);
            }
        }

    };


    /***
     * @ngdoc method
     * @name add
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Add date
     *
     * @param {object} amount The selected amount
     * @param {array} type The start type
     */
    $scope.add = function (amount, type) {
        $scope.selected_day = moment($scope.selected_date);
        switch (type) {
            case 'days':
                setTimeRange($scope.selected_day.add(amount, 'days'));
                break;
            case 'weeks':
                $scope.start_date.add(amount, 'weeks');
                setTimeRange($scope.start_date);
                break;
        }
        return $scope.loadData();
    };

    /***
     * @ngdoc method
     * @name subtract
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Subtract in according of amount and type parameters
     *
     * @param {object} amount The selected amount
     * @param {object} type The start type
     */
    $scope.subtract = (amount, type) => $scope.add(-amount, type);

    /***
     * @ngdoc method
     * @name isSubtractValid
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Verify if the subtract is valid or not
     */
    var isSubtractValid = function () {
        $scope.is_subtract_valid = true;

        let diff = Math.ceil($scope.selected_day.diff(moment(), 'day', true));
        $scope.subtract_length = diff < $scope.time_range_length ? diff : $scope.time_range_length;
        if (diff <= 0) {
            $scope.is_subtract_valid = false;
        }

        if ($scope.subtract_length > 1) {
            return $scope.subtract_string = `Prev ${$scope.subtract_length} days`;
        } else if ($scope.subtract_length === 1) {
            return $scope.subtract_string = "Prev day";
        } else {
            return $scope.subtract_string = "Prev";
        }
    };

    /***
     * @ngdoc method
     * @name isAddValid
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Use to determine if addition of the time range is valid (i.e. it's not more than the max days in advance)
     *
     */
    var isAddValid = function () {
        $scope.is_add_valid = true;

        if (!$scope.isAdmin() && !$scope.options.ignore_max_advance_datetime && $scope.max_date) {
            let max_date = $scope.max_date.clone();
            let selected_day = $scope.selected_day.clone();
            let difference = max_date.startOf('day').diff(selected_day.startOf('day'), 'days', true);
            if (difference - $scope.time_range_length < 0) {
                return $scope.is_add_valid = false;
            }
        }
    };

    /***
     * @ngdoc method
     * @name selectedDateChanged
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Called on datepicker date change
     */
    // called on datepicker date change
    $scope.selectedDateChanged = function () {
        setTimeRange(moment($scope.selected_date));
        $scope.selected_slot = null;
        return $scope.loadData();
    };

    /***
     * @ngdoc method
     * @name updateHideStatus
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Update the hidden status
     */
    let updateHideStatus = () =>
            (() => {
                let result = [];
                for (let key in $scope.days) {
                    let day = $scope.days[key];
                    result.push($scope.days[key].hide = !day.date.isSame($scope.selected_day, 'day'));
                }
                return result;
            })()
        ;


    /***
     * @ngdoc method
     * @name isPast
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Calculate if the current earliest date is in the past - in which case we. Might want to disable going backwards
     */
    // calculate if the current earliest date is in the past - in which case we
    // might want to disable going backwards
    $scope.isPast = function () {
        if (!$scope.start_date) {
            return true;
        }
        return moment().isAfter($scope.start_date);
    };

    /***
     * @ngdoc method
     * @name status
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Check the status of the slot to see if it has been selected
     *
     * @param {date} day The day
     * @param {object} slot The slot of day in multi time range list
     */
    // check the status of the slot to see if it has been selected
    // NOTE: This is very costly to call from a view, please consider using ng-class
    // to access the status
    $scope.status = function (day, slot) {
        if (!slot) {
            return;
        }

        let status = slot.status();
        return status;
    };

    /***
     * @ngdoc method
     * @name highlightSlot
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Check the highlight slot
     *
     * @param {date} day The day
     * @param {object} slot The slot of day in multi time range list
     */
    $scope.highlightSlot = function (slot, day) {

        if (day && slot && (slot.availability() > 0)) {
            $scope.bb.clearStackedItemsDateTime();
            if ($scope.selected_slot) {
                $scope.selected_slot.selected = false;
            }
            $scope.setLastSelectedDate(day.date);
            $scope.selected_slot = angular.copy(slot);
            $scope.selected_day = day.date;
            $scope.selected_date = day.date.toDate();

            // broadcast message to the accordion range groups
            $scope.$broadcast('slotChanged', day, slot);

            // set the date and time on the stacked items
            while (slot) {
                for (let item of Array.from($scope.bb.stacked_items)) {
                    if ((item.service.self === slot.service.self) && !item.date && !item.time) {
                        item.setDate(day);
                        item.setTime(slot);
                        slot = slot.next;
                        break;
                    }
                }
            }

            updateHideStatus();
            return $rootScope.$broadcast("time:selected");
        }
    };

    /***
     * @ngdoc method
     * @name loadData
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Load the time data
     */
    // load the time data
    $scope.loadData = function () {

        loader.notLoaded();

        setMinMaxDate();

        // if the selected date has already been loaded, there's no need to call the API
        if ($scope.request && $scope.request.start.twix($scope.request.end).contains($scope.selected_day)) {
            updateHideStatus();
            loader.setLoaded();
            return;
        }

        $scope.start_date = moment($scope.start_date);
        let edate = moment($scope.start_date).add($scope.time_range_length, 'days');
        $scope.end_date = moment(edate).add(-1, 'days');

        $scope.request = {start: moment($scope.start_date), end: moment($scope.end_date)};

        let pslots = [];
        // group BasketItems's by their service id so that we only call the time data api once for each service
        let grouped_items = _.groupBy($scope.bb.stacked_items, item => item.service.id);
        grouped_items = _.toArray(grouped_items);

        for (var items of Array.from(grouped_items)) {
            pslots.push(TimeService.query({
                company: $scope.bb.company,
                cItem: items[0],
                date: $scope.start_date,
                end_date: $scope.end_date,
                client: $scope.client,
                available: 1
                //duration: duration
            }));
        }

        return $q.all(pslots).then(function (res) {

                $scope.data_valid = true;
                $scope.days = {};

                for (let _i = 0; _i < grouped_items.length; _i++) {
                    items = grouped_items[_i];
                    let slots = res[_i];
                    if (!slots || (slots.length === 0)) {
                        $scope.data_valid = false;
                    }

                    for (let item of Array.from(items)) {
                        // splice the selected times back into the result
                        spliceExistingDateTimes(item, slots);

                        item.slots = {};
                        for (let day of Object.keys(slots || {})) {
                            let times = slots[day];
                            item.slots[day] = _.indexBy(times, 'time');
                        }
                    }
                }

                if ($scope.data_valid) {
                    for (let k in res[0]) {
                        $scope.days[k] = ({date: moment(k)});
                    }
                    setEnabledSlots();
                    updateHideStatus();
                    $rootScope.$broadcast("TimeRangeListStacked:loadFinished");
                }

                return loader.setLoaded();
            }

            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    };

    /***
     * @ngdoc method
     * @name spliceExistingDateTimes
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Splice existing date and times
     *
     * @param {array} stacked_item The stacked item
     * @param {object} slots The slots of stacked_item from the multi_time_range_list
     */
    var spliceExistingDateTimes = function (stacked_item, slots) {

        if (!stacked_item.datetime && !stacked_item.date) {
            return;
        }
        let datetime = stacked_item.datetime || DateTimeUtilitiesService.convertTimeToMoment(stacked_item.date.date, stacked_item.time.time);
        if (($scope.start_date <= datetime) && ($scope.end_date >= datetime)) {
            let time = DateTimeUtilitiesService.convertMomentToTime(datetime);
            let time_slot = _.findWhere(slots[datetime.toISODate()], {time});
            if (!time_slot) {
                time_slot = stacked_item.time;
                slots[datetime.toISODate()].splice(0, 0, time_slot);
            }

            // ensure only the first time slot is marked as selected
            return time_slot.selected = stacked_item.self === $scope.bb.stacked_items[0].self;
        }
    };


    /***
     * @ngdoc method
     * @name setEnabledSlots
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Set the enabled slots
     */
    var setEnabledSlots = () =>

            (() => {
                let result = [];
                for (var day in $scope.days) {

                    var slot, time;
                    var day_data = $scope.days[day];
                    day_data.slots = {};

                    if ($scope.bb.stacked_items.length > 1) {

                        result.push((() => {
                            let result1 = [];
                            for (time in $scope.bb.stacked_items[0].slots[day]) {

                                slot = $scope.bb.stacked_items[0].slots[day][time];
                                let item;
                                slot = angular.copy(slot);

                                let isSlotValid = function (slot) {
                                    ({time} = slot);
                                    let {duration}   = $scope.bb.stacked_items[0].service;
                                    let next = time + duration;

                                    // now loop around the remaining items in the sequence looking for a slot
                                    for (let index = 1, end = $scope.bb.stacked_items.length - 1, asc = 1 <= end; asc ? index <= end : index >= end; asc ? index++ : index--) {
                                        if (!_.isEmpty($scope.bb.stacked_items[index].slots[day]) && $scope.bb.stacked_items[index].slots[day][next]) {
                                            slot.next = angular.copy($scope.bb.stacked_items[index].slots[day][next]);
                                            slot = slot.next;
                                            next = next + $scope.bb.stacked_items[index].service.duration;
                                        } else {
                                            // invalid sequence permutation
                                            return false;
                                        }
                                    }

                                    return true;
                                };

                                // add the slot if it's valid and isn't already in the dataset
                                if (isSlotValid(slot)) {
                                    item = day_data.slots[slot.time] = slot; //if !day_data.slots[slot.time]
                                }
                                result1.push(item);
                            }
                            return result1;
                        })());
                    } else {

                        result.push((() => {
                            let result2 = [];
                            for (time in $scope.bb.stacked_items[0].slots[day]) {
                                slot = $scope.bb.stacked_items[0].slots[day][time];
                                result2.push(day_data.slots[slot.time] = slot);
                            }
                            return result2;
                        })());
                    }
                }
                return result;
            })()
        ;

    /***
     * @ngdoc method
     * @name pretty_month_title
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Display pretty month title in according of month format and year format parameters
     *
     * @param {date} month_format The month format
     * @param {date} year_format The year format
     * @param {string} separator The separator is '-'
     */
    $scope.pretty_month_title = function (month_format, year_format, seperator) {
        let start_date;
        if (seperator == null) {
            seperator = '-';
        }
        if (!$scope.start_date) {
            return;
        }
        let month_year_format = month_format + ' ' + year_format;
        if ($scope.start_date && $scope.end_date && $scope.end_date.isAfter($scope.start_date, 'month')) {
            start_date = $scope.start_date.format(month_format);
            if ($scope.start_date.month() === 11) {
                start_date = $scope.start_date.format(month_year_format);
            }
            return start_date + ' ' + seperator + ' ' + $scope.end_date.format(month_year_format);
        } else {
            return $scope.start_date.format(month_year_format);
        }
    };

    /***
     * @ngdoc method
     * @name confirm
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Confirm the time range stacked
     *
     * @param {string =} route A specific route to load
     * @param {object} options The options
     */
    $scope.confirm = function (route, options) {
        // first check all of the stacked items
        let booking;
        if (options == null) {
            options = {};
        }
        for (var item of Array.from($scope.bb.stacked_items)) {
            if (!item.time) {
                AlertService.add("danger", {msg: "Select a time to continue your booking"});
                return false;
            }
        }

        if (($scope.bb.moving_booking != null) && ($scope.bb.moving_booking.bookings != null)) {
            let different = false;
            for (booking of Array.from($scope.bb.moving_booking.bookings)) {
                let found = false;
                for (item of Array.from($scope.bb.stacked_items)) {
                    if ((booking.getDateString() === item.date.string_date) && (booking.getTimeInMins() === item.time.time) && (booking.category_name === item.category_name)) {
                        found = true;
                    }
                }
                if (!found) {
                    different = true;
                    break;
                }
            }
            if (!different) {
                AlertService.add("danger", {msg: "Your treatments are already booked for this time."});
                return false;
            }
        }

        // empty the current basket quickly
        $scope.bb.basket.clear();

        // add all the stacked items
        $scope.bb.pushStackToBasket();

        if ($scope.bb.moving_booking) {
            // if we're moving - confirm everything in the basket right now
            loader.notLoaded();

            let prom = PurchaseService.update({purchase: $scope.bb.moving_booking, bookings: $scope.bb.basket.items});

            prom.then(function (purchase) {
                    purchase.$getBookings().then(bookings =>
                        (() => {
                            let result = [];
                            for (booking of Array.from(bookings)) {
                                // update bookings
                                let item1;
                                if ($scope.bookings) {
                                    item1 = (() => {
                                        let result1 = [];
                                        for (let _i = 0; _i < $scope.bookings.length; _i++) {
                                            let oldb = $scope.bookings[_i];
                                            let item2;
                                            if (oldb.id === booking.id) {
                                                item2 = $scope.bookings[_i] = booking;
                                            }
                                            result1.push(item2);
                                        }
                                        return result1;
                                    })();
                                }
                                result.push(item1);
                            }
                            return result;
                        })()
                    );
                    loader.setLoaded();
                    $scope.bb.current_item.move_done = true;
                    return $scope.decideNextPage();
                }
                , function (err) {
                    loader.setLoaded();
                    return AlertService.add("danger", {msg: "Failed to move booking"});
                });
            return;
        }

        loader.notLoaded();

        if (options.do_not_route) {
            return $scope.updateBasket();
        } else {
            return $scope.updateBasket().then(function () {
                    loader.setLoaded();
                    return $scope.decideNextPage(route);
                }
                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
        }
    };

    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbTimeRangeStacked
     * @description
     * Set this page section as ready
     */
    return $scope.setReady = () => $scope.confirm('', {do_not_route: true});
});
