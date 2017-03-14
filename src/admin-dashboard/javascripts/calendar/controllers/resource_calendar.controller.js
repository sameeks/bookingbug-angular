angular.module('BBAdminDashboard.calendar.controllers').controller('bbResourceCalendarController', function (AdminBookingPopup,
                                                                                                             AdminCalendarOptions, AdminCompanyService, AdminMoveBookingPopup, $attrs, BBAssets, BBModel, $bbug, CalendarEventSources,
                                                                                                             ColorPalette, Dialog, $filter, GeneralOptions, ModalForm, PrePostTime, ProcessAssetsFilter, $q, $rootScope, $scope,
                                                                                                             $state, TitleAssembler, $translate, $window, uiCalendarConfig, CompanyStoreService) {
    'ngInject';

    /*jshint validthis: true */
    let vm = this;

    let filters = null;

    let company = null;
    let companyServices = [];

    let calOptions = [];

    vm.assets = []; // All options sets (resources, people) go to the same select

    vm.selectedResources = {
        selected: []
    };

    let init = function () {
        applyFilters();

        prepareCalOptions();
        prepareEventSources();
        prepareUiCalOptions();

        $scope.$watch('selectedResources.selected', selectedResourcesListener);

        $scope.$on('refetchBookings', refetchBookingsHandler);
        $scope.$on('newCheckout', newCheckoutHandler);
        $scope.$on('BBLanguagePicker:languageChanged', languageChangedHandler);
        $scope.$on('CalendarEventSources:timeRangeChanged', timeRangeChangedHandler);

        $rootScope.$on('BBTimezoneOptions:timezoneChanged', timezoneChangedHandler);

        getCompanyPromise().then(companyListener);

        vm.changeSelectedResources = changeSelectedResources;
        vm.updateDateHandler = updateDateHandler;
    };

    let applyFilters = function () {
        filters = {
            requestedAssets: ProcessAssetsFilter($state.params.assets)
        };

        vm.showAll = filters.requestedAssets.length <= 0;
    };

    let setTimeToMoment = function (date, time) {
        let newDate = moment(time, 'HH:mm');
        newDate.set({
            'year': parseInt(date.get('year')),
            'month': parseInt(date.get('month')),
            'date': parseInt(date.get('date')),
            'second': 0
        });
        return newDate;
    };

    let prepareEventSources = function () {
        vm.eventSources = [
            {events: getEvents}
        ];
    };

    let getEvents = function (start, end, timezone, callback) {
        vm.loading = true;
        getCompanyPromise().then(function (company) {
            let options = {
                labelAssembler: $scope.labelAssembler ? $scope.labelAssembler : AdminCalendarOptions.bookings_label_assembler,
                blockLabelAssembler: $scope.blockLabelAssembler ? $scope.blockLabelAssembler : AdminCalendarOptions.block_label_assembler,
                externalLabelAssembler: $scope.externalLabelAssembler ? $scope.externalLabelAssembler : AdminCalendarOptions.external_label_assembler,
                noCache: true,
                showAll: vm.showAll,
                type: calOptions.type,
                selectedResources: vm.selectedResources.selected,
                calendarView: uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('getView').type
            };

            if ($scope.model) {
                options.showAll = false;
                options.selectedResources = [$scope.model];
            }

            return CalendarEventSources.getAllCalendarEntries(company, start, end, options).then(function (results) {
                vm.loading = false;
                return callback(results);
            });
        });
    };

    let prepareCalOptions = function () {
        calOptions = $scope.$eval($attrs.bbResourceCalendar);
        if (!calOptions) {
            calOptions = {};
        }

        if (!calOptions.defaultView) {
            if ($scope.model) {
                calOptions.defaultView = 'agendaWeek';
            } else {
                calOptions.defaultView = 'timelineDay';
            }
        }

        if (!calOptions.views) {
            if ($scope.model) {
                calOptions.views = 'listDay,timelineDayThirty,agendaWeek,month';
            } else {
                calOptions.views = 'timelineDay,listDay,timelineDayThirty,agendaWeek,month';
            }
        }

        // height = if calOptions.header_height
        //   $bbug($window).height() - calOptions.header_height
        // else
        //   800

        if (calOptions.name) {
            vm.calendar_name = calOptions.name;
        } else {
            vm.calendar_name = 'resourceCalendar';
        }

        if (calOptions.cal_slot_duration == null) {
            calOptions.cal_slot_duration = GeneralOptions.calendar_slot_duration;
        }

    };

    let prepareUiCalOptions = function () {
        vm.uiCalOptions = { // @todo REPLACE ALL THIS WITH VARIABLES FROM THE GeneralOptions Service
            calendar: {
                editable: true,
                schedulerLicenseKey: '0598149132-fcs-1443104297',
                eventStartEditable: false,
                eventDurationEditable: false,
                height: 'auto',
                buttonText: {},
                header: {
                    left: 'today,prev,next',
                    center: 'title',
                    right: calOptions.views
                },
                defaultView: calOptions.defaultView,
                views: {
                    listDay: {},
                    agendaWeek: {
                        slotDuration: $filter('minutesToString')(calOptions.cal_slot_duration),
                        groupByDateAndResource: false
                    },
                    month: {
                        eventLimit: 5
                    },
                    timelineDay: {
                        slotDuration: $filter('minutesToString')(calOptions.cal_slot_duration),
                        eventOverlap: false,
                        slotWidth: 25,
                        resourceAreaWidth: '18%'
                    }
                },
                resourceGroupField: 'group',
                resourceLabelText: ' ',
                eventResourceEditable: true,
                selectable: true,
                lazyFetching: false,
                columnFormat: AdminCalendarOptions.column_format,
                resources: fcResources,
                eventDragStop: fcEventDragStop,
                eventDrop: fcEventDrop,
                eventClick: fcEventClick,
                eventRender: fcEventRender,
                eventAfterRender: fcEventAfterRender,
                eventAfterAllRender: fcEventAfterAllRender,
                select: fcSelect,
                viewRender: fcViewRender,
                eventResize: fcEventResize,
                loading: fcLoading,
                ignoreTimezone: false,
                timezone: GeneralOptions.display_time_zone
            }
        };
        updateCalendarLanguage();
        updateCalendarTimeRange();
    };

    let updateCalendarLanguage = function () {
        vm.uiCalOptions.calendar.locale = $translate.use();
        vm.uiCalOptions.calendar.buttonText.today = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
        vm.uiCalOptions.calendar.views.listDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
        vm.uiCalOptions.calendar.views.agendaWeek.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.WEEK');
        vm.uiCalOptions.calendar.views.month.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MONTH');
        vm.uiCalOptions.calendar.views.timelineDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.DAY', {minutes: calOptions.cal_slot_duration});
    };

    let updateCalendarTimeRange = function () {
        vm.uiCalOptions.calendar.minTime = AdminCalendarOptions.minTime;
        vm.uiCalOptions.calendar.maxTime = AdminCalendarOptions.maxTime;
    };

    let fcResources = callback => getCalendarAssets(callback);

    let fcEventDragStop = function (event, jsEvent, ui, view) {
        event.oldResourceIds = event.resourceIds;
    };

    let fcEventDrop = function (booking, delta, revertFunc) { // we need a full move cal if either it has a person and resource, or they've dragged over multiple days

        if (GeneralOptions.custom_time_zone) {
            let calendar = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('getCalendar');
            booking.start = calendar.moment(moment.tz(booking.start.toISOString(), GeneralOptions.display_time_zone));
            booking.end = calendar.moment(moment.tz(booking.end.toISOString(), GeneralOptions.display_time_zone));
        }

        // not blocked and is a change in person/resource, or over multiple days
        if ((booking.status !== 3) && ((booking.person_id && booking.resource_id) || (delta.days() > 0))) {
            let {start} = booking;
            let {end} = booking;
            if (GeneralOptions.custom_time_zone) {
                start = moment.tz(start, CompanyStoreService.time_zone);
                end = moment.tz(end, CompanyStoreService.time_zone);
            }

            let item_defaults = {
                date: start.format('YYYY-MM-DD'),
                time: ((start.hour() * 60) + start.minute())
            };

            if (booking.resourceId) {
                //let orginal_resource;
                let newAssetId = booking.resourceId.substring(0, booking.resourceId.indexOf('_'));
                if (booking.resourceId.indexOf('_p') > -1) {
                    item_defaults.person = newAssetId;
                    //orginal_resource = `${event.person_id}_p`;
                } else if (booking.resourceId.indexOf('_r') > -1) {
                    item_defaults.resource = newAssetId;
                    //orginal_resource = `${event.resource_id}_r`;
                }
            }

            getCompanyPromise().then(company =>
                AdminMoveBookingPopup.open({
                    min_date: setTimeToMoment(start, AdminCalendarOptions.minTime),
                    max_date: setTimeToMoment(end, AdminCalendarOptions.maxTime),
                    from_datetime: moment(start.toISOString()),
                    to_datetime: moment(end.toISOString()),
                    item_defaults,
                    company_id: company.id,
                    booking_id: booking.id,
                    success: model => {
                        return refreshBooking(booking);
                    },
                    fail() {
                        refreshBooking(booking);
                        return revertFunc();
                    }
                })
            );
            return;
        }

        // if it's got a person and resource - then it
        return Dialog.confirm({
            title: $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MOVE_MODAL_HEADING'),
            model: booking,
            body: $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MOVE_MODAL_BODY'),
            success: model => {
                if (GeneralOptions.custom_time_zone) {
                    booking.start = moment.tz(booking.start, CompanyStoreService.time_zone);
                    booking.end = moment.tz(booking.end, CompanyStoreService.time_zone);
                }
                return updateBooking(booking);
            },
            fail() {
                revertFunc();
            }
        });
    };

    let fcEventClick = function (booking, jsEvent, view) {
        if (booking.type === 'external') return;

        if (booking.$has('edit')) {
            return editBooking(booking);
        }
    };

    let fcEventRender = function (booking, element) {
        let {type} = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('getView');
        let service = _.findWhere(companyServices, {id: booking.service_id});
        if (!$scope.model) {  // if not a single item view
            let a, link;
            if (type === 'listDay') {
                link = $bbug(element.children()[2]);
                if (link) {
                    a = link.children()[0];
                    if (a) {
                        if (booking.person_name && (!calOptions.type || (calOptions.type === 'person'))) {
                            a.innerHTML = booking.person_name + ' - ' + a.innerHTML;
                        } else if (booking.resource_name && (calOptions.type === 'resource')) {
                            a.innerHTML = booking.resource_name + ' - ' + a.innerHTML;
                        }
                    }
                }
            } else if ((type === 'agendaWeek') || (type === 'month')) {
                link = $bbug(element.children()[0]);
                if (link) {
                    a = link.children()[1];
                    if (a) {
                        if (booking.person_name && (!calOptions.type || (calOptions.type === 'person'))) {
                            a.innerHTML = booking.person_name + '<br/>' + a.innerHTML;
                        } else if (booking.resource_name && (calOptions.type === 'resource')) {
                            a.innerHTML = booking.resource_name + '<br/>' + a.innerHTML;
                        }
                    }
                }
            }
        }
        if (service && (type !== 'listDay')) {
            element.css('background-color', service.color);
            element.css('color', service.textColor);
            element.css('border-color', service.textColor);
        }
        return element;
    };

    let fcEventAfterRender = function (event, elements, view) {
        if ((event.rendering == null) || (event.rendering !== 'background')) {
            return PrePostTime.apply(event, elements, view, $scope);
        }
    };

    let fcEventAfterAllRender = function () {
        $scope.$emit('UICalendar:EventAfterAllRender');
    };

    let fcSelect = function (start, end, jsEvent, view, resource) { // For some reason clicking on the scrollbars triggers this event therefore we filter based on the jsEvent target
        if (jsEvent && (jsEvent.target.className === 'fc-scroller')) {
            return;
        }

        if (GeneralOptions.custom_time_zone) {
            let calendar = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('getCalendar');
            start = calendar.moment(moment.tz(moment(start.toISOString()), CompanyStoreService.time_zone));
            end = calendar.moment(moment.tz(moment(end.toISOString()), CompanyStoreService.time_zone));
        }

        view.calendar.unselect();

        if (!calOptions.enforce_schedules || (isTimeRangeAvailable(start, end, resource) || ((Math.abs(start.diff(end, 'days')) === 1) && dayHasAvailability(start)))) {
            if (Math.abs(start.diff(end, 'days')) > 0) {
                end.subtract(1, 'days');
                end = setTimeToMoment(end, AdminCalendarOptions.maxTime);
            }

            let item_defaults = {
                date: start.format('YYYY-MM-DD'),
                time: ((start.hour() * 60) + start.minute())
            };

            if (resource && (resource.type === 'person')) {
                item_defaults.person = resource.id.substring(0, resource.id.indexOf('_'));
            } else if (resource && (resource.type === 'resource')) {
                item_defaults.resource = resource.id.substring(0, resource.id.indexOf('_'));
            }

            return getCompanyPromise().then(company =>
                AdminBookingPopup.open({
                    min_date: setTimeToMoment(start, AdminCalendarOptions.minTime),
                    max_date: setTimeToMoment(end, AdminCalendarOptions.maxTime),
                    from_datetime: moment(start.toISOString()),
                    to_datetime: moment(end.toISOString()),
                    item_defaults,
                    first_page: 'quick_pick',
                    on_conflict: 'cancel()',
                    company_id: company.id
                })
            );
        }
    };

    let fcViewRender = function (view, element) {
        let date = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('getDate');
        let newDate = moment().tz(moment.tz.guess());
        newDate.set({
            'year': parseInt(date.get('year')),
            'month': parseInt(date.get('month')),
            'date': parseInt(date.get('date')),
            'hour': 0,
            'minute': 0,
            'second': 0
        });
        return vm.currentDate = newDate.toDate();
    };

    let fcEventResize = function (booking, delta, revertFunc, jsEvent, ui, view) {
        booking.duration = booking.end.diff(booking.start, 'minutes');
        return updateBooking(booking);
    };

    let fcLoading = function (isLoading, view) {
        vm.calendarLoading = isLoading;
    };

    let isTimeRangeAvailable = function (start, end, resource) {
        let st = moment(start.toISOString()).unix();
        let en = moment(end.toISOString()).unix();
        let events = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('clientEvents', event => (event.rendering === 'background') && (st >= event.start.unix()) && event.end && (en <= event.end.unix()) && ((resource && (parseInt(event.resourceId) === parseInt(resource.id))) || !resource));
        return events.length > 0;
    };

    let dayHasAvailability = function (start) {
        let events = uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('clientEvents', event => (event.rendering === 'background') && (event.start.year() === start.year()) && (event.start.month() === start.month()) && (event.start.date() === start.date()));

        return events.length > 0;
    };

    let selectedResourcesListener = function (newValue, oldValue) {
        if (newValue !== oldValue) {
            let assets = [];
            angular.forEach(newValue, asset => assets.push(asset.id));

            let {params} = $state;
            params.assets = assets.join();
            $state.go($state.current.name, params, {notify: false, reload: false});
        }
    };

    let getCalendarAssets = function (callback) {
        if ($scope.model) {
            callback([$scope.model]);
            return;
        }

        vm.loading = true;

        getCompanyPromise().then(function (company) {
            if (vm.showAll) {
                BBAssets.getAssets(company).then(function (assets) {
                    if (calOptions.type) {
                        assets = _.filter(assets, a => a.type === calOptions.type);
                    }

                    for (let asset of Array.from(assets)) {
                        asset.id = asset.identifier;
                    }

                    vm.loading = false;
                    return callback(assets);
                });
            } else {
                vm.loading = false;
                callback(vm.selectedResources.selected);
            }
        });

    };

    let getBookingTitle = function (booking) {
        let labelAssembler = $scope.labelAssembler ? $scope.labelAssembler : AdminCalendarOptions.bookings_label_assembler;
        let blockLabelAssembler = $scope.blockLabelAssembler ? $scope.blockLabelAssembler : AdminCalendarOptions.block_label_assembler;

        if ((booking.status !== 3) && labelAssembler) {
            return TitleAssembler.getTitle(booking, labelAssembler);
        } else if ((booking.status === 3) && blockLabelAssembler) {
            return TitleAssembler.getTitle(booking, blockLabelAssembler);
        }

        return booking.title;
    };

    let refreshBooking = function (booking) {
        booking.$refetch().then(function (response) {
            booking.resourceIds = [];
            booking.resourceId = null;
            if (booking.person_id != null) {
                booking.resourceIds.push(booking.person_id + '_p');
            }
            if (booking.resource_id != null) {
                booking.resourceIds.push(booking.resource_id + '_r');
            }

            booking.title = getBookingTitle(booking);

            return uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('updateEvent', booking);
        });
    };

    let updateBooking = function (booking) {
        if (booking.resourceId) {
            let newAssetId = booking.resourceId.substring(0, booking.resourceId.indexOf('_'));
            if (booking.resourceId.indexOf('_p') > -1) {
                booking.person_id = newAssetId;
            } else if (booking.resourceId.indexOf('_r') > -1) {
                booking.resource_id = newAssetId;
            }
        }

        booking.$update().then(function (response) {
            booking.resourceIds = [];
            booking.resourceId = null;
            if (booking.person_id != null) {
                booking.resourceIds.push(booking.person_id + '_p');
            }
            if (booking.resource_id != null) {
                booking.resourceIds.push(booking.resource_id + '_r');
            }

            booking.title = getBookingTitle(booking);

            return uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('updateEvent', booking);
        });
    };

    let editBooking = function (booking) {
        let templateUrl, title;
        if (GeneralOptions.custom_time_zone) {
            booking.datetime = moment.tz(moment(booking.datetime.toISOString()), CompanyStoreService.time_zone);
        }
        if (booking.status === 3) {
            templateUrl = 'edit_block_modal_form.html';
            title = 'Edit Block';
        } else {
            templateUrl = 'edit_booking_modal_form.html';
            title = 'Edit Booking';
        }
        ModalForm.edit({
            templateUrl,
            model: booking,
            title,
            params: {
                locale: $translate.use()
            },
            success: response => {
                if (typeof response === 'string') {
                    if (response === 'move') {
                        let item_defaults = {person: booking.person_id, resource: booking.resource_id};
                        getCompanyPromise().then(company =>
                            AdminMoveBookingPopup.open({
                                item_defaults,
                                company_id: company.id,
                                booking_id: booking.id,
                                success: model => {
                                    return refreshBooking(booking);
                                },
                                fail() {
                                    return refreshBooking(booking);
                                }
                            })
                        );
                    }
                }
                else if (response.is_cancelled) {
                    return uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('removeEvents', [response.id]);
                } else {
                    booking.title = getBookingTitle(booking);
                    return uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('updateEvent', booking);
                }
            }
        });
    };

    let pusherBooking = function (res) {
        if (res.id != null) {
            let booking = _.first(uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('clientEvents', res.id));
            if (booking && booking.$refetch) {
                booking.$refetch().then(function () {
                    booking.title = getBookingTitle(booking);
                    return uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('updateEvent', booking);
                });
            } else {
                uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('refetchEvents');
            }
        }
    };

    let pusherSubscribe = () => {
        if (company) {
            let pusher_channel = company.getPusherChannel('bookings');
            if (pusher_channel) {
                pusher_channel.bind('create', pusherBooking);
                pusher_channel.bind('update', pusherBooking);
                pusher_channel.bind('destroy', pusherBooking);
            }
        }
    };

    let updateDateHandler = function (data) {
        if (uiCalendarConfig.calendars[vm.calendar_name]) {
            let assembledDate = moment.utc();
            assembledDate.set({
                'year': parseInt(data.date.getFullYear()),
                'month': parseInt(data.date.getMonth()),
                'date': parseInt(data.date.getDate()),
                'hour': 0,
                'minute': 0,
                'second': 0,
            });
            uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('gotoDate', assembledDate);
        }
    };

    let refetchBookingsHandler = function () {
        uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('refetchEvents');
    };

    let newCheckoutHandler = function () {
        uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('refetchEvents');
    };

    var timezoneChangedHandler = function(event, tz) {
        uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('option', 'timezone', tz);
    };

    var languageChangedHandler = function () {
        updateCalendarLanguage();
    };

    let timeRangeChangedHandler = function () {
        updateCalendarTimeRange();
    };

    let getCompanyPromise = function () {
        let defer = $q.defer();
        if (company) {
            defer.resolve(company);
        } else {
            AdminCompanyService.query($attrs).then(function (_company) {
                company = _company;
                return defer.resolve(company);
            });
        }
        return defer.promise;
    };

    let changeSelectedResources = function () {
        if (vm.showAll) {
            vm.selectedResources.selected = [];
        }

        uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('refetchResources');
        uiCalendarConfig.calendars[vm.calendar_name].fullCalendar('refetchEvents');
    };

    let assetsListener = function (assets) {
        for (let asset of Array.from(assets)) {
            asset.id = asset.identifier;
        }
        vm.loading = false;

        if (calOptions.type) {
            assets = _.filter(assets, a => a.type === calOptions.type);
        }
        vm.assets = assets;

        // requestedAssets
        if (filters.requestedAssets.length > 0) {
            angular.forEach(vm.assets, function (asset) {
                let isInArray = _.find(filters.requestedAssets, id => id === asset.id);

                if (typeof isInArray !== 'undefined') {
                    return vm.selectedResources.selected.push(asset);
                }
            });

            changeSelectedResources();
        }
    };

    /**
     * {Object} company
     */
    let companyListener = function (company) {
        vm.loading = true;

        BBAssets.getAssets(company).then(assetsListener);

        company.$get('services').then(collectionListener);

        pusherSubscribe();
    };

    /**
     * {Object} baseResourceCollection
     */
    let collectionListener = function (collection) {
        collection.$get('services').then(servicesListener);
    };

    /**
     * {Array.<Object>} services
     */
    let servicesListener = function (services) {
        companyServices = (Array.from(services).map((service) => new BBModel.Admin.Service(service)));
        ColorPalette.setColors(companyServices);
    };

    init();
});
