// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('EventList', function ($scope, $rootScope, EventService, EventChainService, EventGroupService, $q, FormDataStoreService, $filter, PaginationService, $timeout, ValidatorService, LoadingService, BBModel) {

    let i;
    let loader = LoadingService.$loader($scope).notLoaded();

    $scope.pick = {};
    $scope.start_date = moment();
    $scope.end_date = moment().add(1, 'year');
    $scope.filters = {hide_fully_booked_events: false};
    $scope.pagination = PaginationService.initialise({page_size: 10, max_size: 5});
    $scope.events = {};
    $scope.fully_booked = false;
    $scope.event_data_loaded = false;

    FormDataStoreService.init('EventList', $scope, [
        'selected_date',
        'event_group_id',
        'event_group_manually_set'
    ]);

    $rootScope.connection_started.then(function () {

            if ($scope.bb.company) {
                // if there's a default event, skip this step
                if (($scope.bb.item_defaults && $scope.bb.item_defaults.event) || ($scope.bb.current_item.defaults && $scope.bb.current_item.defaults.event)) {

                    $scope.skipThisStep();
                    $scope.decideNextPage();
                    return;

                } else if ($scope.bb.company.$has('parent') && !$scope.bb.company.$has('company_questions')) {

                    return $scope.bb.company.$getParent().then(function (parent) {
                            $scope.company_parent = parent;
                            return $scope.initialise();
                        }
                        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

                } else {

                    return $scope.initialise();
                }
            }
        }

        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));


    $scope.initialise = function () {

        let event_group;
        loader.notLoaded();

        if ($scope.mode !== 0) {
            delete $scope.selected_date;
        }

        // has the event group been manually set (i.e. in the step before)
        if (!$scope.event_group_manually_set && ($scope.bb.current_item.event_group == null)) {
            $scope.event_group_manually_set = ($scope.event_group_manually_set == null) && ($scope.bb.current_item.event_group != null);
        }

        // clear current item
        if ($scope.bb.current_item.event) {
            ({event_group} = $scope.bb.current_item);
            $scope.clearBasketItem();
            // TODO only remove the basket items added in this session
            $scope.emptyBasket();
            if ($scope.event_group_manually_set) {
                $scope.bb.current_item.setEventGroup(event_group);
            }
        }

        let promises = [];

        // company question promise
        if ($scope.bb.company.$has('company_questions')) {
            promises.push($scope.bb.company.$getCompanyQuestions());
        } else if (($scope.company_parent != null) && $scope.company_parent.$has('company_questions')) {
            promises.push($scope.company_parent.$getCompanyQuestions());
        } else {
            promises.push($q.when([]));
            $scope.has_company_questions = false;
        }

        // event group promise
        if ($scope.bb.item_defaults && $scope.bb.item_defaults.event_group) {
            $scope.bb.current_item.setEventGroup($scope.bb.item_defaults.event_group);
        } else if (!$scope.bb.current_item.event_group && $scope.bb.company.$has('event_groups')) {
            // --------------------------------------------------------------------------------
            // By default, the API returns the first 100 event_groups. We don't really want
            // to paginate event_groups (athough we DO want to paginate events)
            // so I have hardcoded the EventGroupService query to return all event_groups
            // by passing in a suitably high number for the per_page param
            // ---------------------------------------------------------------------------------
            promises.push(EventGroupService.query($scope.bb.company, {per_page: 500}));
        } else {
            promises.push($q.when([]));
        }

        // event summary promise
        if (($scope.mode === 0) || ($scope.mode === 2)) {
            promises.push($scope.loadEventSummary());
        } else {
            promises.push($q.when([]));
        }

        // event data promise
        // TODO - always load some event data?
        if (($scope.mode === 1) || ($scope.mode === 2)) {
            promises.push($scope.loadEventData());
        } else {
            promises.push($q.when([]));
        }


        return $q.all(promises).then(function (result) {
                let company_questions = result[0];
                let event_groups = result[1];
                let event_summary = result[2];
                let event_data = result[3];

                $scope.has_company_questions = (company_questions != null) && (company_questions.length > 0);
                if (company_questions) {
                    buildDynamicFilters(company_questions);
                }
                $scope.event_groups = event_groups;

                // Add EventGroup to Event so we don't have to make network requests using item.getGroup() from the view
                let event_groups_collection = _.indexBy(event_groups, 'id');
                if ($scope.items) {
                    for (let item of Array.from($scope.items)) {
                        item.group = event_groups_collection[item.service_id];
                    }
                }

                // Remove loading icon
                return loader.setLoaded();
            }

            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
    };


    /***
     * @ngdoc method
     * @name loadEventSummary
     * @methodOf BB.Directives:bbEvents
     * @description
     * Load event summary
     */
    $scope.loadEventSummary = function () {

        let deferred = $q.defer();
        let current_event = $scope.bb.current_item.event;

        // de-select the event chain if there's one already picked - as it's hiding other events in the same group
        if ($scope.bb.current_item && ($scope.bb.current_item.event_chain_id || $scope.bb.current_item.event_chain)) {
            delete $scope.bb.current_item.event_chain;
            delete $scope.bb.current_item.event_chain_id;
        }

        let comp = $scope.bb.company;

        let params = {
            item: $scope.bb.current_item,
            start_date: $scope.start_date.toISODate(),
            end_date: $scope.end_date.toISODate()
        };

        if ($scope.bb.item_defaults.event_chain) {
            params.event_chain_id = $scope.bb.item_defaults.event_chain.id;
        }

        BBModel.Event.$summary(comp, params).then(function (items) {

                let item_dates;
                if (items && (items.length > 0)) {

                    item_dates = [];
                    for (let item of Array.from(items)) {
                        let d = moment(item);
                        item_dates.push({
                            date: d,
                            idate: parseInt(d.format("YYYYDDDD")),
                            count: 1,
                            spaces: 1,
                        });
                    }

                    $scope.item_dates = item_dates.sort((a, b) => a.idate - b.idate);

                    // TODO clear the selected date if the event group has changed (but only when event group has been explicity set)
                    // if $scope.bb.current_item? and $scope.bb.current_item.event_group?
                    //   if $scope.bb.current_item.event_group.id != $scope.event_group_id
                    //     $scope.showDay($scope.item_dates[0].date)
                    //   $scope.event_group_id = $scope.bb.current_item.event_group.id

                    // if the selected date is within range of the dates loaded, show it, else show the first day loaded
                    if ($scope.mode === 0) {
                        if ($scope.selected_date && ($scope.selected_date.isAfter($scope.item_dates[0].date) || $scope.selected_date.isSame($scope.item_dates[0].date)) && ($scope.selected_date.isBefore($scope.item_dates[$scope.item_dates.length - 1].date) || $scope.selected_date.isSame($scope.item_dates[$scope.item_dates.length - 1].date))) {
                            $scope.showDay($scope.selected_date);
                        } else {
                            $scope.showDay($scope.item_dates[0].date);
                        }
                    }
                }

                return deferred.resolve($scope.item_dates);
            }

            , err => deferred.reject());

        return deferred.promise;
    };


    /***
     * @ngdoc method
     * @name loadEventChainData
     * @methodOf BB.Directives:bbEvents
     * @description
     * Load event chain data in according of comp parameter
     *
     * @param {array} comp The company
     */
    $scope.loadEventChainData = function (comp) {

        let deferred = $q.defer();

        if ($scope.bb.item_defaults.event_chain) {
            deferred.resolve([]);
        } else {
            loader.notLoaded();
            if (!comp) {
                comp = $scope.bb.company;
            }

            let params = {
                item: $scope.bb.current_item,
                start_date: $scope.start_date.toISODate(),
                end_date: $scope.end_date.toISODate()
            };
            if ($scope.events_options.embed) {
                params.embed = $scope.events_options.embed;
            }
            if ($scope.client) {
                params.member_level_id = $scope.client.member_level_id;
            }

            BBModel.EventChain.$query(comp, params).then(function (event_chains) {
                    loader.setLoaded();
                    return deferred.resolve(event_chains);
                }
                , err => deferred.reject());
        }

        return deferred.promise;
    };


    /***
     * @ngdoc method
     * @name loadEventData
     * @methodOf BB.Directives:bbEvents
     * @description
     * Load event data. De-select the event chain if there's one already picked - as it's hiding other events in the same group
     *
     * @param {array} comp The company parameter
     */
    $scope.loadEventData = function (comp) {

        loader.notLoaded();

        $scope.event_data_loaded = false;

        // clear the items when in summary mode
        if ($scope.mode === 0) {
            delete $scope.items;
        }

        let deferred = $q.defer();

        let current_event = $scope.bb.current_item.event;

        if (!comp) {
            comp = $scope.bb.company;
        }

        // de-select the event chain if there's one already picked - as it's hiding other events in the same group
        if ($scope.bb.current_item && ($scope.bb.current_item.event_chain_id || $scope.bb.current_item.event_chain)) {
            delete $scope.bb.current_item.event_chain;
            delete $scope.bb.current_item.event_chain_id;
        }

        let params = {
            item: $scope.bb.current_item,
            start_date: $scope.start_date.toISODate(),
            end_date: $scope.end_date.toISODate(),
            include_non_bookable: true
        };

        if ($scope.events_options.event_data_embed) {
            params.embed = $scope.events_options.event_data_embed;
        }

        if ($scope.bb.item_defaults.event_chain) {
            params.event_chain_id = $scope.bb.item_defaults.event_chain.id;
        }

        if ($scope.per_page) {
            params.per_page = $scope.per_page;
        }

        let chains = $scope.loadEventChainData(comp);

        $scope.events = {};

        BBModel.Event.$query(comp, params).then(function (events) {

                // Flatten events array
                $scope.items = _.flatten(events);

                // Add spaces_left prop - so we don't need to use ng-init="spaces_left = getSpacesLeft()" in the html template
                for (var item of Array.from($scope.items)) {
                    item.spaces_left = item.getSpacesLeft();
                }

                // Add address prop from the company to the item
                if ($scope.bb.company.$has('address')) {

                    $scope.bb.company.$getAddress().then(address =>

                        (() => {
                            let result = [];
                            for (item of Array.from($scope.items)) {
                                result.push(item.address = address);
                            }
                            return result;
                        })()
                    );
                }

                // TODO make this behave like the frame timetable
                // get all data then process events
                return chains.then(function () {

                        // get more event details
                        for (item of Array.from($scope.items)) {

                            params =
                                {embed: $scope.events_options.embed};
                            if ($scope.client) {
                                params.member_level_id = $scope.client.member_level_id;
                            }
                            item.prepEvent(params);

                            // check if the current item already has the same event selected
                            if (($scope.mode === 0) && current_event && (current_event.self === item.self)) {

                                item.select();
                                $scope.event = item;
                            }
                        }

                        // only build item_dates if we're in 'next 100 event' mode
                        if ($scope.mode === 1) {

                            let idate;
                            let item_dates = {};

                            if (items.length > 0) {

                                for (item of Array.from(items)) {

                                    item.getDuration();
                                    idate = parseInt(item.date.format("YYYYDDDD"));
                                    item.idate = idate;

                                    if (!item_dates[idate]) {
                                        item_dates[idate] = {date: item.date, idate, count: 0, spaces: 0};
                                    }

                                    item_dates[idate].count += 1;
                                    item_dates[idate].spaces += item.num_spaces;
                                }

                                $scope.item_dates = [];

                                for (let x in item_dates) {

                                    let y = item_dates[x];
                                    $scope.item_dates.push(y);
                                }

                                $scope.item_dates = $scope.item_dates.sort((a, b) => a.idate - b.idate);

                            } else {

                                idate = parseInt($scope.start_date.format("YYYYDDDD"));
                                $scope.item_dates = [{date: $scope.start_date, idate, count: 0, spaces: 0}];
                            }
                        }

                        // determine if all events are fully booked
                        $scope.isFullyBooked();

                        $scope.filtered_items = $scope.items;

                        // run the filters to ensure any default filters get applied
                        $scope.filterChanged();

                        // update the paging
                        PaginationService.update($scope.pagination, $scope.filtered_items.length);

                        loader.setLoaded();
                        $scope.event_data_loaded = true;

                        return deferred.resolve($scope.items);
                    }

                    , err => deferred.reject());
            }

            , err => deferred.reject());

        return deferred.promise;
    };


    /***
     * @ngdoc method
     * @name isFullyBooked
     * @methodOf BB.Directives:bbEvents
     * @description
     * Verify if the items from event list are be fully booked
     */
    $scope.isFullyBooked = function () {

        let full_events = [];

        for (let item of Array.from($scope.items)) {

            if (item.num_spaces === item.spaces_booked) {
                full_events.push(item);
            }
        }

        if (full_events.length === $scope.items.length) {
            return $scope.fully_booked = true;
        }
    };


    /***
     * @ngdoc method
     * @name showDay
     * @methodOf BB.Directives:bbEvents
     * @description
     * Selects a day or filters events by day selected
     *
     * @param {moment} the day to select or filter by
     */
    $scope.showDay = function (date) {

        let new_date;
        if (!moment.isMoment(date)) {
            return;
        }

        if ($scope.mode === 0) {

            // unselect the event if it's not on the day being selected
            if ($scope.event && !$scope.selected_date.isSame(date, 'day')) {
                delete $scope.event;
            }
            new_date = date;
            $scope.start_date = moment(date);
            $scope.end_date = moment(date);
            $scope.loadEventData();

        } else {

            if (!$scope.selected_date || !date.isSame($scope.selected_date, 'day')) {
                new_date = date;
            }
        }

        if (new_date) {

            $scope.selected_date = new_date;
            $scope.filters.date = new_date.toDate();

        } else {

            delete $scope.selected_date;
            delete $scope.filters.date;
        }

        return $scope.filterChanged();
    };


    $scope.$watch('pick.date', (new_val, old_val) => {

            if (new_val) {

                $scope.start_date = moment(new_val);
                $scope.end_date = moment(new_val);
                return $scope.loadEventData();
            }
        }
    );


    /***
     * @ngdoc method
     * @name selectItem
     * @methodOf BB.Directives:bbEvents
     * @description
     * Select an item into the current event list in according of item and route parameters
     *
     * @param {array} item The Event or BookableItem to select
     * @param {string=} route A specific route to load
     */
    $scope.selectItem = (item, route) => {

        if (((item.getSpacesLeft() > 0) || !$scope.bb.company.settings.has_waitlists) && !item.hasSpace()) {
            return false;
        }

        loader.notLoaded();

        if ($scope.$parent.$has_page_control) {

            if ($scope.event) {
                $scope.event.unselect();
            }
            $scope.event = item;
            $scope.event.select();
            loader.setLoaded();

            return false;

        } else {

            if ($scope.bb.moving_purchase) {

                for (i of Array.from($scope.bb.basket.items)) {
                    i.setEvent(item);
                }
            }

            $scope.bb.current_item.setEvent(item);
            $scope.bb.current_item.ready = false;

            $q.all($scope.bb.current_item.promises).then(() => $scope.decideNextPage(route)

                , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

            return true;
        }
    };


    /***
     * @ngdoc method
     * @name setReady
     * @methodOf BB.Directives:bbEvents
     * @description
     * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
     */
    $scope.setReady = function () {

        if (!$scope.event) {
            return false;
        }

        $scope.bb.current_item.setEvent($scope.event);

        return true;
    };


    /***
     * @ngdoc method
     * @name filterEvents
     * @methodOf BB.Directives:bbEvents
     * @description
     * Filter events from the event list in according of item parameter
     *
     * @param {array} item The Event or BookableItem to select
     */
    $scope.filterEvents = function (item) {
        let result = item.bookable &&
            (moment($scope.filters.date).isSame(item.date, 'day') || ($scope.filters.date == null)) &&
            (($scope.filters.event_group && (item.service_id === $scope.filters.event_group.id)) || ($scope.filters.event_group == null)) &&
            ((($scope.filters.price != null) && (item.price_range.from <= $scope.filters.price)) || ($scope.filters.price == null)) &&
            (($scope.filters.hide_fully_booked_events && (item.getSpacesLeft() > 0)) || !$scope.filters.hide_fully_booked_events) &&
            $scope.filterEventsWithDynamicFilters(item);

        return result;
    };


    $scope.filterEventsWithDynamicFilters = function (item) {

        if (!$scope.has_company_questions || !$scope.dynamic_filters) {
            return true;
        }

        let result = true;

        for (let type of Array.from($scope.dynamic_filters.question_types)) {

            var dynamic_filter, filter, name;
            if (type === 'check') {

                for (dynamic_filter of Array.from($scope.dynamic_filters['check'])) {

                    name = dynamic_filter.name.parameterise('_');
                    filter = false;

                    if (item.chain && item.chain.extra[name]) {

                        for (i of Array.from(item.chain.extra[name])) {
                            filter = ($scope.dynamic_filters.values[dynamic_filter.name] && (i === $scope.dynamic_filters.values[dynamic_filter.name].name)) || ($scope.dynamic_filters.values[dynamic_filter.name] == null);

                            if (filter) {
                                break;
                            }
                        }

                    } else if ((item.chain.extra[name] === undefined) && (_.isEmpty($scope.dynamic_filters.values) || ($scope.dynamic_filters.values[dynamic_filter.name] == null))) {

                        filter = true;
                    }

                    result = result && filter;
                }

            } else {

                for (dynamic_filter of Array.from($scope.dynamic_filters[type])) {

                    name = dynamic_filter.name.parameterise('_');
                    filter = ($scope.dynamic_filters.values[dynamic_filter.name] && (item.chain.extra[name] === $scope.dynamic_filters.values[dynamic_filter.name].name)) || ($scope.dynamic_filters.values[dynamic_filter.name] == null);
                    result = result && filter;
                }
            }
        }

        return result;
    };


    /***
     * @ngdoc method
     * @name filterDateChanged
     * @methodOf BB.Directives:bbEvents
     * @description
     * Filtering data exchanged from the list of events
     */
    $scope.filterDateChanged = function (options) {

        if (options == null) {
            options = {reset: false};
        }
        if ($scope.filters.date) {
            let date = moment($scope.filters.date);
            $scope.$broadcast("event_list_filter_date:changed", date);
            $scope.showDay(date);

            if ((options.reset === true) || ($scope.selected_date == null)) {

                return $timeout(() => delete $scope.filters.date
                    , 250);
            }
        }
    };


    /***
     * @ngdoc method
     * @name resetFilters
     * @methodOf BB.Directives:bbEvents
     * @description
     * Reset the filters
     */
    $scope.resetFilters = function () {

        $scope.filters = {};
        if ($scope.has_company_questions) {
            $scope.dynamic_filters.values = {};
        }
        $scope.filterChanged();

        delete $scope.selected_date;
        return $rootScope.$broadcast("event_list_filter_date:cleared");
    };


    // build dynamic filters using company questions
    var buildDynamicFilters = function (questions) {

        questions = _.each(questions, question => question.name = $filter('wordCharactersAndSpaces')(question.name));

        $scope.dynamic_filters = _.groupBy(questions, 'question_type');
        $scope.dynamic_filters.question_types = _.uniq(_.pluck(questions, 'question_type'));
        return $scope.dynamic_filters.values = {};
    };


    // TODO build price filter by determiniug price range, if range is large enough, display price filter
    // buildPriceFilter = () ->
    //   for item in items


    let sort = function () {
    };
    // TODO allow sorting by price/date (default)


    /***
     * @ngdoc method
     * @name filterChanged
     * @methodOf BB.Directives:bbEvents
     * @description
     * Change filter of the event list
     */
    $scope.filterChanged = function () {

        if ($scope.items) {

            $scope.filtered_items = $filter('filter')($scope.items, $scope.filterEvents);
            $scope.pagination.num_items = $scope.filtered_items.length;
            $scope.filter_active = $scope.filtered_items.length !== $scope.items.length;
            return PaginationService.update($scope.pagination, $scope.filtered_items.length);
        }
    };


    /***
     * @ngdoc method
     * @name pageChanged
     * @methodOf BB.Directives:bbEvents
     * @description
     * Change page of the event list
     */
    return $scope.pageChanged = function () {

        PaginationService.update($scope.pagination, $scope.filtered_items.length);
        return $rootScope.$broadcast("page:changed");
    };
});


// TODO load more events when end of initial collection is reached/next collection is requested/data is loaded when no event data is present
// $scope.$on 'month_picker:month_changed', (event, month, last_month_shown) ->
//   return if !$scope.items or $scope.mode is 0
//   last_event = _.last($scope.items).date
//   # if the last event is in the same month as the last one shown, get more events
//   if last_month_shown.start_date.isSame(last_event, 'month')
//     $scope.start_date = last_month_shown.start_date
//     $scope.loadEventData()
