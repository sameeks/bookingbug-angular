angular.module('BB.Controllers').controller('TimeRangeList', function ($scope, $element,
                                                                       $attrs, $rootScope, $q, AlertService, LoadingService, BBModel,
                                                                       FormDataStoreService, DateTimeUtilitiesService, SlotDates, viewportSize, ErrorService) {

    // store the form data for the following scope properties
    let currentPostcode = $scope.bb.postcode;

    FormDataStoreService.init('TimeRangeList', $scope, [
        'selected_slot',
        'postcode',
        'original_start_date',
        'start_at_week_start'
    ]);

    // check to see if the user has changed the postcode and remove data if they have
    if (currentPostcode !== $scope.postcode) {
        $scope.selected_slot = null;
        $scope.selected_date = null;
    }

    // store the postocde
    $scope.postcode = $scope.bb.postcode;

    // show the loading icon
    let loader = LoadingService.$loader($scope).notLoaded();

    // if the data source isn't set, set it as the current item
    if (!$scope.data_source) {
        $scope.data_source = $scope.bb.current_item;
    }

    $rootScope.connection_started.then(() => $scope.initialise());


    /***
     * @ngdoc method
     * @name initialise
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Set time range in according of selected date and start date parameters
     *
     */
    $scope.initialise = function () {

        // read initialisation attributes
        let selected_day;
        if ($attrs.bbTimeRangeLength != null) {
            $scope.time_range_length = $scope.$eval($attrs.bbTimeRangeLength);
        } else if ($scope.options && $scope.options.time_range_length) {
            $scope.time_range_length = $scope.options.time_range_length;
        } else {
            let calculateDayNum = function () {
                let cal_days = {lg: 7, md: 5, sm: 3, xs: 1};

                let timeRange = 7;

                for (let size in cal_days) {
                    let days = cal_days[size];
                    if (size === viewportSize.getViewportSize()) {
                        timeRange = days;
                    }
                }

                return timeRange;
            };

            $scope.time_range_length = calculateDayNum();

            $scope.$on('viewportSize:changed', function () {
                $scope.time_range_length = null;
                return $scope.initialise();
            });
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
            // if the time range list was initialised with a selected_day, restore the view so that
            // selected day remains relative to where the first day that was originally shown
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
        } else if ($scope.bb.current_item.date || $scope.bb.current_item.defaults.date) {
            let date = $scope.bb.current_item.date ? $scope.bb.current_item.date.date : $scope.bb.current_item.defaults.date;
            setTimeRange(date);
            // selected day has been provided, use this to set the time
        } else if ($scope.selected_day) {
            $scope.original_start_date = $scope.original_start_date || moment($scope.selected_day);
            setTimeRange($scope.selected_day);
            // set the time range to show the current week
        } else {
            $scope.start_at_week_start = true;
            setTimeRange(moment());
        }

        return $scope.loadData();
    };

    var markSelectedSlot = function (time_slots) {
        var selected_slot = _.find(time_slots, function (slot) {
            return $scope.bb.current_item.date &&
                $scope.bb.current_item.date.date.isSame(slot.datetime, 'day') &&
                $scope.bb.current_item.time &&
                $scope.bb.current_item.time.time === slot.time;
        });
        if (selected_slot) {
            return selected_slot.selected = true;
        }
    };


    /***
     * @ngdoc method
     * @name setTimeRange
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Set time range in according of selected date and start date parameters
     *
     * @param {date} selected_date The selected date
     * @param {date} start_date The start date
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
     * @methodOf BB.Directives:bbTimeRanges
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
     * @name moment
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Add to moment date in according of date parameter
     *
     * @param {date} date The date
     */
    $scope.moment = date => moment(date);

    /***
     * @ngdoc method
     * @name setDataSource
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Set data source in according of source parameter
     *
     * @param {array} source The source of data
     */
    $scope.setDataSource = source => $scope.data_source = source;


    // when the current item is updated, reload the time data
    $scope.$on("currentItemUpdate", event => $scope.loadData());


    /***
     * @ngdoc method
     * @name add
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Add new time range in according of type and amount parameters
     *
     * @param {object} type The type
     * @param {object} amount The amount of the days
     */
    $scope.add = function (type, amount) {
        if (amount > 0) {
            $element.removeClass('subtract');
            $element.addClass('add');
        }
        switch (type) {
            case 'days':
                setTimeRange($scope.start_date.add(amount, 'days'));
                break;
            case 'weeks':
                $scope.start_date.add(amount, type);
                setTimeRange($scope.start_date);
                break;
            case 'months':
// TODO make this advance to the next month
                $scope.start_date.add(amount, type).startOf('month');
                setTimeRange($scope.start_date);
                break;
        }
        return $scope.loadData();
    };

    /***
     * @ngdoc method
     * @name subtract
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Substract amount
     *
     * @param {object} type The type
     * @param {object} amount The amount of the days
     */
    $scope.subtract = function (type, amount) {
        $element.removeClass('add');
        $element.addClass('subtract');
        return $scope.add(type, -amount);
    };


    /***
     * @ngdoc method
     * @name isSubtractValid
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Use to determine if subtraction of the time range is valid (i.e. it's not in the past)
     *
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
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Use to determine if addition of the time range is valid (i.e. it's not more than the max days in advance)
     *
     */
    var isAddValid = function () {
        $scope.is_add_valid = true;

        if (!$scope.isAdmin() && !$scope.options.ignore_max_advance_datetime && $scope.max_date) {
            let max_date = $scope.max_date.clone()
            let selected_day = $scope.selected_day.clone()
            let difference = max_date.startOf('day').diff(selected_day.startOf('day'), 'days', true);
            if (difference - $scope.time_range_length < 0) {
                return $scope.is_add_valid = false;
            }
        }
    };

    /***
     * @ngdoc method
     * @name selectedDateChanged
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Select date change
     *
     */
    // called on datepicker date change
    $scope.selectedDateChanged = function () {
        setTimeRange(moment($scope.selected_date));
        $scope.selected_slot = null;
        return $scope.loadData();
    };

    /***
     * @ngdoc method
     * @name isPast
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Calculate if the current earliest date is in the past - in which case we might want to disable going backwards
     *
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
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Check the status of the slot to see if it has been selected
     *
     * @param {date} day The day
     * @param {array} slot The slot
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
    // the view was originally calling the slot.status(). this logic below is for
    // storing the time but we're not doing this for now so we just return status
    // selected = $scope.selected_slot
    // if selected and selected.time is slot.time and selected.date is slot.date
    //   return status = 'selected'
    // return status

    /***
     * @ngdoc method
     * @name selectSlot
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Called when user selects a time slot use this when you want to route to the next step as a slot is selected
     *
     * @param {date} day The day
     * @param {array} slot The slot
     * @param {string=} route A route of the selected slot
     */
    $scope.selectSlot = function (slot, day, route) {

        if (slot && (slot.availability() > 0)) {

            $scope.bb.current_item.setTime(slot);

            if (slot.datetime) {
                $scope.setLastSelectedDate(slot.datetime);
                $scope.bb.current_item.setDate({date: slot.datetime});
            } else if (day) {
                $scope.setLastSelectedDate(day.date);
                $scope.bb.current_item.setDate(day);
            }

            if ($scope.bb.current_item.reserve_ready) {
                loader.notLoaded();
                return $scope.addItemToBasket().then(function () {
                        loader.setLoaded();
                        return $scope.decideNextPage(route);
                    }
                    , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
            } else {
                return $scope.decideNextPage(route);
            }
        }
    };

    /***
     * @ngdoc method
     * @name highlightSlot
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Called when user selects a time slot use this when you just want to hightlight the the slot and not progress to the next step
     *
     * @param {date} day The day
     * @param {array} slot The slot
     */
    $scope.highlightSlot = function (slot, day) {

        let {current_item} = $scope.bb;

        if (slot && (slot.availability() > 0) && !slot.disabled) {

            if (slot.datetime) {
                $scope.setLastSelectedDate(slot.datetime);
                current_item.setDate({date: slot.datetime.clone().tz($scope.bb.company.timezone)});
            } else if (day) {
                $scope.setLastSelectedDate(day.date);
                current_item.setDate(day);
            }

            current_item.setTime(slot);
            $scope.selected_slot = slot;
            $scope.selected_day = day.date;
            $scope.selected_date = day.date.toDate();

            if ($scope.bb.current_item.earliest_time_slot && $scope.bb.current_item.earliest_time_slot.selected && (!$scope.bb.current_item.earliest_time_slot.date.isSame(day.date, 'day') || ($scope.bb.current_item.earliest_time_slot.time !== slot.time))) {
                $scope.bb.current_item.earliest_time_slot.selected = false;
            }

            $rootScope.$broadcast("time:selected");

            // broadcast message to the accordion range groups
            return $scope.$broadcast('slotChanged', day, slot);
        }
    };

    /***
     * @ngdoc method
     * @name loadData
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Load the time data
     *
     */
    $scope.loadData = function () {

        setMinMaxDate();

        let date = $scope.start_date;
        let edate = moment(date).add($scope.time_range_length, 'days');
        $scope.end_date = moment(edate).add(-1, 'days');

        AlertService.clear();
        // We may not want the current item duration to be the duration we query by
        // If min_duration is set, pass that into the api, else pass in the duration
        let {duration} = $scope.bb.current_item;
        if ($scope.bb.current_item.min_duration) {
            duration = $scope.bb.current_item.min_duration;
        }

        if ($scope.data_source && $scope.data_source.days_link) {
            $scope.notLoaded($scope);
            let loc = null;
            if ($scope.bb.postcode) {
                loc = `,,,,${$scope.bb.postcode},`;
            }

            let promise = BBModel.TimeSlot.$query({
                company: $scope.bb.company,
                resource_ids: $scope.bb.item_defaults.resources,
                cItem: $scope.data_source,
                date,
                client: $scope.client,
                end_date: $scope.end_date,
                duration,
                location: loc,
                num_resources: $scope.bb.current_item.num_resources,
                available: 1
            });

            promise.finally(() => loader.setLoaded());

            return promise.then(function (datetime_arr) {

                    let time_slots;
                    $scope.days = [];

                    if (_.every(_.values(datetime_arr), _.isEmpty)) {
                        $scope.no_slots_in_week = true;
                    } else {
                        $scope.no_slots_in_week = false;
                    }

                    let utc = moment().utc();
                    let utcHours = utc.format('H');
                    let utcMinutes = utc.format('m');
                    let utcSeconds = utc.format('s');

                    // sort time slots to be in chronological order
                    for (let pair of Array.from(_.sortBy(_.pairs(datetime_arr), pair => pair[0]))) {
                        var slot;
                        let d = pair[0];
                        time_slots = pair[1];

                        // make sure the selected slot is marked as selected
                        // we dont to mark the slot when we are moving a booking
                        if(angular.isUndefined($scope.bb.purchase)) {
                            markSelectedSlot(time_slots);
                        }

                        let day = {
                            date: moment(d).add(utcHours, 'hours').add(utcMinutes, 'minutes').add(utcSeconds, 'seconds'),
                            slots: time_slots
                        };
                        $scope.days.push(day);

                        if (time_slots.length > 0) {
                            if (!$scope.bb.current_item.earliest_time || $scope.bb.current_item.earliest_time.isAfter(d)) {
                                $scope.bb.current_item.earliest_time = moment(d).add(time_slots[0].time, 'minutes');
                            }
                            if (!$scope.bb.current_item.earliest_time_slot || $scope.bb.current_item.earliest_time_slot.date.isAfter(d)) {
                                $scope.bb.current_item.earliest_time_slot = {
                                    date: moment(d).add(time_slots[0].time, 'minutes'),
                                    time: time_slots[0].time
                                };
                            }
                        }

                        // padding is used to ensure that a list of time slots is always padded
                        // out with a certain of values if it's a partial set of results
                        if ($scope.add_padding && (time_slots.length > 0)) {
                            let dtimes = {};
                            for (slot of Array.from(time_slots)) {
                                dtimes[slot.time] = 1;
                                // add date to slot as well
                                slot.date = day.date.format('DD-MM-YY');
                            }

                            for (let v = 0; v < $scope.add_padding.length; v++) {
                                let pad = $scope.add_padding[v];
                                if (!dtimes[pad]) {
                                    time_slots.splice(v, 0, new BBModel.TimeSlot({
                                        time: pad,
                                        avail: 0
                                    }, time_slots[0].service));
                                }
                            }
                        }

                        let requested_slot = DateTimeUtilitiesService.checkDefaultTime(day.date, day.slots, $scope.bb.current_item, $scope.bb.item_defaults);

                        if (requested_slot.slot && (requested_slot.match === "full")) {
                            $scope.skipThisStep();
                            $scope.selectSlot(requested_slot.slot, day);
                        } else if (requested_slot.slot) {
                            $scope.highlightSlot(requested_slot.slot, day);
                        }
                    }

                    if(angular.isDefined($scope.bb.purchase)) {
                        $scope.bb.current_item.clearDateTime();
                    }


                    return $scope.$broadcast("time_slots:loaded", time_slots);
                }

                , function (err) {
                    if ((err.status === 404) && err.data && err.data.error && (err.data.error === "No bookable events found")) {
                        if ($scope.data_source && $scope.data_source.person) {
                            AlertService.warning(ErrorService.getError('NOT_BOOKABLE_PERSON'));
                            $scope.setLoaded($scope);
                        } else if ($scope.data_source && $scope.data_source.resource) {
                            AlertService.warning(ErrorService.getError('NOT_BOOKABLE_RESOURCE'));
                            $scope.setLoaded($scope);
                        }

                        return $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                    } else {
                        return $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong');
                    }
                });
        } else {
            return loader.setLoaded();
        }
    };

    $scope.showFirstAvailableDay = () =>
        SlotDates.getFirstDayWithSlots($scope.data_source, $scope.selected_day).then(function (day) {
                $scope.no_slots_in_week = false;
                setTimeRange(day);
                return $scope.loadData();
            }
            , err => loader.setLoadedAndShowError($scope, err, 'Sorry, something went wrong'))
    ;
    /***
     * @ngdoc method
     * @name padTimes
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * The pad time
     *
     * @param {date} times The times
     */
    $scope.padTimes = times => $scope.add_padding = times;


    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Set this page section as ready
     */
    $scope.setReady = function () {
        if (!$scope.bb.current_item.time) {
            AlertService.raise('TIME_SLOT_NOT_SELECTED');
            return false;
        } else if ($scope.bb.moving_booking && $scope.bb.current_item.start_datetime().isSame($scope.bb.current_item.original_datetime) && ($scope.bb.current_item.person_name === $scope.bb.current_item.person.name)) {
            AlertService.raise('APPT_AT_SAME_TIME');
            return false;
        } else if ($scope.bb.moving_booking) {
// set a 'default' person and resource if we need them, but haven't picked any in moving
            if ($scope.bb.company.$has('resources') && !$scope.bb.current_item.resource) {
                $scope.bb.current_item.resource = true;
            }
            if ($scope.bb.company.$has('people') && !$scope.bb.current_item.person) {
                $scope.bb.current_item.person = true;
            }
            return true;
        } else {
            if ($scope.bb.current_item.reserve_ready) {
                return $scope.addItemToBasket();
            } else {
                return true;
            }
        }
    };


    /***
     * @ngdoc method
     * @name pretty_month_title
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Format the month title in according of month formant, year format and separator parameters
     *
     * @param {date} month_format The month format
     * @param {date} year_format The year format
     * @param {object} separator The separator of month and year format
     */
    $scope.pretty_month_title = function (month_format, year_format, seperator) {
        let start_date;
        if (seperator == null) {
            seperator = '-';
        }
        if (!$scope.start_date || !$scope.end_date) {
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
     * @name selectEarliestTimeSlot
     * @methodOf BB.Directives:bbTimeRanges
     * @description
     * Select earliest time slot
     */
    return $scope.selectEarliestTimeSlot = function () {
        let day = _.find($scope.days, day => day.date.isSame($scope.bb.current_item.earliest_time_slot.date, 'day'));
        let slot = _.find(day.slots, slot => slot.time === $scope.bb.current_item.earliest_time_slot.time);

        if (day && slot) {
            $scope.bb.current_item.earliest_time_slot.selected = true;
            return $scope.highlightSlot(day, slot);
        }
    };
});
