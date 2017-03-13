angular.module('BBAdminDashboard.calendar.controllers').service('BbFullCalendar',
    function (AdminCalendarOptions, AdminCompanyService, CalendarEventSources, GeneralOptions, $translate, $filter,
              uiCalendarConfig, $q, BBModel, AdminMoveBookingPopup, AdminBookingPopup, Dialog, TitleAssembler,
              ModalForm, $bbug, BBAssets, ColorPalette, PrePostTime, ProcessAssetsFilter) {
        'ngInject';

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

        class BbFullCalendar {
            constructor() {
                this.setOptions();
            }

            setOptions() {
                this.name = 'calendar';
                this.type = null;
                this.slotDuration = GeneralOptions.calendar_slot_duration;

                this.model = null;

                this.company = null;
                this.companyServices = [];

                this.assets = []; // All options sets (resources, people) go to the same select

                this.selectedResources = {
                    selected: []
                };

                this.currentDate = null;

                this.eventSources = [
                    {events: this.getEvents.bind(this)}
                ];

                this.loading = false;

                this.enforceSchedules = null;

                this.filters = {};

                this.$scope = null;


                this.bookingsLabelAssembler = AdminCalendarOptions.bookings_label_assembler;
                this.blockLabelAssembler = AdminCalendarOptions.block_label_assembler;
                this.externalLabelAssembler = AdminCalendarOptions.external_label_assembler;


                this.calendar = {
                    schedulerLicenseKey: '0598149132-fcs-1443104297',
                    eventStartEditable: false,
                    eventDurationEditable: false,
                    height: 'auto',
                    buttonText: {},
                    header: {
                        left: 'today,prev,next',
                        center: 'title',
                        right: 'listDay,timelineDayThirty,agendaWeek,month'
                    },
                    defaultView: 'timelineDay',
                    views: {
                        listDay: {},
                        agendaWeek: {
                            slotDuration: $filter('minutesToString')(this.slotDuration),
                            groupByDateAndResource: false
                        },
                        month: {
                            eventLimit: 5
                        },
                        timelineDay: {
                            slotDuration: $filter('minutesToString')(this.slotDuration),
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
                    resources: this.fcResources.bind(this),
                    eventDragStop: this.fcEventDragStop.bind(this),
                    eventDrop: this.fcEventDrop.bind(this),
                    eventClick: this.fcEventClick.bind(this),
                    eventRender: this.fcEventRender.bind(this),
                    eventAfterRender: this.fcEventAfterRender.bind(this),
                    eventAfterAllRender: this.fcEventAfterAllRender.bind(this),
                    select: this.fcSelect.bind(this),
                    viewRender: this.fcViewRender.bind(this),
                    eventResize: this.fcEventResize.bind(this),
                    loading: this.fcLoading.bind(this)
                };

                this.updateCalendarLanguage();
                this.updateCalendarTimeRange();
                this.getCompanyPromise().then(
                    () => {
                        this.companyListener();
                    }
                );
            }

            updateCalendarLanguage() {
                this.calendar.locale = $translate.use();
                this.calendar.buttonText.today = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
                this.calendar.views.listDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.TODAY');
                this.calendar.views.agendaWeek.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.WEEK');
                this.calendar.views.month.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MONTH');
                this.calendar.views.timelineDay.buttonText = $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.DAY',
                    {minutes: this.slotDuration}
                );
            }

            updateCalendarTimeRange() {
                this.calendar.minTime = AdminCalendarOptions.minTime;
                this.calendar.maxTime = AdminCalendarOptions.maxTime;
            }

            getCompanyPromise() {
                let defer = $q.defer();
                if (this.company) {
                    defer.resolve(this.company);
                } else {
                    AdminCompanyService.query(this.$attrs).then( //TODO is it ok to use $attrs in service?
                        (_company) => {
                            this.company = _company;
                            return defer.resolve(this.company);
                        }
                    );
                }
                return defer.promise;
            }

            companyListener() {
                this.loading = true;

                BBAssets.getAssets(this.company).then(this.assetsListener.bind(this));

                this.company.$get('services').then(
                    (collection) => {
                        collection.$get('services').then(
                            (services) => {
                                this.companyServices = (
                                    Array.from(services).map(
                                        (service) => {
                                            return new BBModel.Admin.Service(service);
                                        }
                                    )
                                );
                                ColorPalette.setColors(this.companyServices);
                            }
                        );
                    }
                );

                this.pusherSubscribe();
            }

            pusherSubscribe() {
                if (this.company) {
                    let pusher_channel = this.company.getPusherChannel('bookings');
                    if (pusher_channel) {
                        pusher_channel.bind('create', this.pusherBooking.bind(this));
                        pusher_channel.bind('update', this.pusherBooking.bind(this));
                        pusher_channel.bind('destroy', this.pusherBooking.bind(this));
                    }
                }
            }

            pusherBooking(res) {
                if (res.id != null) {
                    let booking = _.first(uiCalendarConfig.calendars[this.name].fullCalendar('clientEvents', res.id));

                    if (booking && booking.$refetch) {
                        booking.$refetch().then(
                            () => {
                                booking.title = this.getBookingTitle(booking);
                                return uiCalendarConfig.calendars[this.name].fullCalendar('updateEvent', booking);
                            }
                        );
                    } else {
                        uiCalendarConfig.calendars[this.name].fullCalendar('refetchEvents');
                    }
                }
            }

            assetsListener(assets) {
                for (let asset of Array.from(assets)) {
                    asset.id = asset.identifier;
                }
                this.loading = false;

                if (this.type) {
                    assets = _.filter(assets, a => a.type === this.type);
                }
                this.assets = assets;

                // requestedAssets
                if (this.filters.requestedAssets.length > 0) {
                    angular.forEach(this.assets,
                        (asset) => {
                            let isInArray = _.find(this.filters.requestedAssets, id => id === asset.id);

                            if (typeof isInArray !== 'undefined') {
                                return this.selectedResources.selected.push(asset);
                            }
                        }
                    );

                    this.changeSelectedResources();
                }
            }

            changeSelectedResources() {
                if (this.showAll) {
                    this.selectedResources.selected = [];
                }

                uiCalendarConfig.calendars[this.name].fullCalendar('refetchResources');
                uiCalendarConfig.calendars[this.name].fullCalendar('refetchEvents');
            }

            setRequestedAssets(assets) {
                this.filters.requestedAssets = ProcessAssetsFilter(assets);
                this.showAll = this.filters.requestedAssets.length <= 0;
            }

            updateDateHandler(data) {
                if (uiCalendarConfig.calendars[this.name]) {
                    let assembledDate = moment.utc();
                    assembledDate.set({
                        'year': parseInt(data.date.getFullYear()),
                        'month': parseInt(data.date.getMonth()),
                        'date': parseInt(data.date.getDate()),
                        'hour': 0,
                        'minute': 0,
                        'second': 0,
                    });
                    uiCalendarConfig.calendars[this.name].fullCalendar('gotoDate', assembledDate);
                }
            }

            /**
             * @param {string} view ['agendaWeek'|'timelineDay']
             */
            setDefaultView(view) {
                this.calendar.defaultView = view;
            }

            /**
             * @param {string} views CSV e.g. 'timelineDay,listDay,timelineDayThirty,agendaWeek,month'
             */
            setHeaderRightViews(views) {
                this.calendar.header.right = views
            }

            /**
             * @param {string} name
             */
            setName(name) {
                this.name = name;
            }

            setScope(scope) {
                this.$scope = scope;
            }

            setAttrs(attrs) {
                this.$attrs = attrs;
            }

            setModel(model) {
                this.model = model;
            }

            /**
             * @param {number} slotDuration Number of minutes
             */
            setSlotDuration(slotDuration) {
                this.slotDuration = slotDuration;

                this.calendar.views.agendaWeek.slotDuration = $filter('minutesToString')(this.slotDuration);
                this.calendar.views.timelineDay.slotDuration = $filter('minutesToString')(this.slotDuration);
                this.updateCalendarLanguage();
            }

            /**
             * @param {String} labelAssembler
             */
            setBookingsLabelAssembler(labelAssembler) {
                this.bookingsLabelAssembler = labelAssembler;
            }

            setBlockLabelAssembler(labelAssembler) {
                this.blockLabelAssembler = labelAssembler;
            }

            setExternalLabelAssembler(labelAssembler) {
                this.externalLabelAssembler = labelAssembler;
            }

            setType(type) {
                this.type = type;
            }

            setEnforceSchedules(enforceSchedules) {
                this.enforceSchedules = enforceSchedules;
            }

            getEvents(start, end, timezone, callback) {
                this.loading = true;
                this.getCompanyPromise().then(
                    (company) => {
                        let options = {
                            labelAssembler: this.bookingsLabelAssembler,
                            blockLabelAssembler: this.blockLabelAssembler,
                            externalLabelAssembler: this.externalLabelAssembler,
                            noCache: true,
                            showAll: this.showAll,
                            type: this.type,
                            selectedResources: this.selectedResources.selected,
                            calendarView: uiCalendarConfig.calendars[this.name].fullCalendar('getView').type
                        };

                        if (this.model) {
                            options.showAll = false;
                            options.selectedResources = [this.model];
                        }

                        return CalendarEventSources.getAllCalendarEntries(company, start, end, options).then(
                            (results) => {
                                this.loading = false;
                                return callback(results);
                            }
                        );
                    }
                );
            }

            fcResources(callback) {
                return this.getCalendarAssets(callback);
            }

            getCalendarAssets(callback) {

                if (this.model) {
                    callback([this.model]);
                    return;
                }

                this.loading = true;

                this.getCompanyPromise().then(
                    (company) => {
                        if (this.showAll) {
                            BBAssets.getAssets(company).then(
                                (assets) => {
                                    if (this.type) {
                                        assets = _.filter(assets, a => a.type === this.type);
                                    }

                                    for (let asset of Array.from(assets)) {
                                        asset.id = asset.identifier;
                                    }

                                    this.loading = false;
                                    return callback(assets);
                                }
                            );
                        } else {
                            this.loading = false;
                            callback(this.selectedResources.selected);
                        }
                    }
                );

            }

            fcEventDragStop(event, jsEvent, ui, view) {
                event.oldResourceIds = event.resourceIds;
            }

            fcEventDrop(event, delta, revertFunc) { // we need a full move cal if either it has a person and resource, or they've dragged over multiple days
                let adminBooking = new BBModel.Admin.Booking(event);

                // not blocked and is a change in person/resource, or over multiple days
                if ((adminBooking.status !== 3) && ((adminBooking.person_id && adminBooking.resource_id) || (delta.days() > 0))) {

                    let item_defaults = {
                        date: adminBooking._start.format('YYYY-MM-DD'),
                        time: ((adminBooking._start.hour() * 60) + adminBooking._start.minute())
                    };

                    console.log('item_defaults', item_defaults);

                    if (adminBooking.resourceId) {
                        //let orginal_resource;
                        let newAssetId = adminBooking.resourceId.substring(0, adminBooking.resourceId.indexOf('_'));
                        if (adminBooking.resourceId.indexOf('_p') > -1) {
                            item_defaults.person = newAssetId;
                            //orginal_resource = `${event.person_id}_p`;
                        } else if (adminBooking.resourceId.indexOf('_r') > -1) {
                            item_defaults.resource = newAssetId;
                            //orginal_resource = `${event.resource_id}_r`;
                        }
                    }

                    this.getCompanyPromise().then(
                        (company) => {
                            AdminMoveBookingPopup.open({
                                min_date: setTimeToMoment(adminBooking._start, AdminCalendarOptions.minTime),
                                max_date: setTimeToMoment(adminBooking._end, AdminCalendarOptions.maxTime),
                                from_datetime: moment(adminBooking._start.toISOString()),
                                to_datetime: moment(adminBooking._end.toISOString()),
                                item_defaults,
                                company_id: company.id,
                                booking_id: adminBooking.id,
                                success: (model) => {
                                    this.refreshBooking(adminBooking);
                                },
                                fail: () => {
                                    this.refreshBooking(adminBooking);
                                    revertFunc();
                                }
                            });
                        }
                    );
                    return;
                }

                // if it's got a person and resource - then it
                return Dialog.confirm({
                    title: $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MOVE_MODAL_HEADING'),
                    model: adminBooking,
                    body: $translate.instant('ADMIN_DASHBOARD.CALENDAR_PAGE.MOVE_MODAL_BODY'),
                    success: (model) => {
                        return this.updateBooking(adminBooking);
                    },
                    fail: () => {
                        return revertFunc();
                    }
                });
            }

            refreshBooking(booking) {
                booking.$refetch().then(
                    (response) => {
                        booking.resourceIds = [];
                        booking.resourceId = null;

                        if (booking.person_id != null) {
                            booking.resourceIds.push(booking.person_id + '_p');
                        }

                        if (booking.resource_id != null) {
                            booking.resourceIds.push(booking.resource_id + '_r');
                        }

                        booking.title = this.getBookingTitle(booking);

                        return uiCalendarConfig.calendars[this.name].fullCalendar('updateEvent', booking);
                    }
                );
            }

            getBookingTitle(booking) {
                let labelAssembler = this.bookingsLabelAssembler;
                let blockLabelAssembler = this.blockLabelAssembler;

                if ((booking.status !== 3) && labelAssembler) {
                    return TitleAssembler.getTitle(booking, labelAssembler);
                } else if ((booking.status === 3) && blockLabelAssembler) {
                    return TitleAssembler.getTitle(booking, blockLabelAssembler);
                }

                return booking.title;
            }

            updateBooking(adminBooking) {
                if (adminBooking.resourceId) {
                    let newAssetId = adminBooking.resourceId.substring(0, adminBooking.resourceId.indexOf('_'));
                    if (adminBooking.resourceId.indexOf('_p') > -1) {
                        adminBooking.person_id = newAssetId;
                    } else if (adminBooking.resourceId.indexOf('_r') > -1) {
                        adminBooking.resource_id = newAssetId;
                    }
                }

                adminBooking.$update().then( // TODO - that doesn't work for moving BLOCKS
                    (response) => {
                        adminBooking.resourceIds = [];
                        adminBooking.resourceId = null;
                        if (adminBooking.person_id != null) {
                            adminBooking.resourceIds.push(adminBooking.person_id + '_p');
                        }
                        if (adminBooking.resource_id != null) {
                            adminBooking.resourceIds.push(adminBooking.resource_id + '_r');
                        }

                        adminBooking.title = this.getBookingTitle(adminBooking);

                        return uiCalendarConfig.calendars[this.name].fullCalendar('updateEvent', adminBooking);
                    }
                );
            }

            fcSelect(start, end, jsEvent, view, resource) { // For some reason clicking on the scrollbars triggers this event therefore we filter based on the jsEvent target
                if (jsEvent && (jsEvent.target.className === 'fc-scroller')) {
                    return;
                }

                view.calendar.unselect();

                if (!this.enforceSchedules || (this.isTimeRangeAvailable(start, end, resource) ||
                    ((Math.abs(start.diff(end, 'days')) === 1) && this.dayHasAvailability(start)))) {

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

                    return this.getCompanyPromise().then(
                        (company) => {
                            AdminBookingPopup.open({
                                    min_date: setTimeToMoment(start, AdminCalendarOptions.minTime),
                                    max_date: setTimeToMoment(end, AdminCalendarOptions.maxTime),
                                    from_datetime: moment(start.toISOString()),
                                    to_datetime: moment(end.toISOString()),
                                    item_defaults,
                                    first_page: "quick_pick",
                                    on_conflict: "cancel()",
                                    company_id: company.id
                                }
                            );
                        }
                    );
                }
            }

            isTimeRangeAvailable(start, end, resource) {
                let st = moment(start.toISOString()).unix();
                let en = moment(end.toISOString()).unix();
                let events = uiCalendarConfig.calendars[this.name].fullCalendar('clientEvents',
                    (event) => {
                        return (event.rendering === 'background') &&
                            (st >= event.start.unix()) &&
                            event.end &&
                            (en <= event.end.unix()) &&
                            ((resource && (parseInt(event.resourceId) === parseInt(resource.id))) || !resource)
                    }
                );
                return events.length > 0;
            }

            dayHasAvailability(start) {
                let events = uiCalendarConfig.calendars[this.name].fullCalendar('clientEvents',
                    (event) => {
                        return (event.rendering === 'background') &&
                            (event.start.year() === start.year()) &&
                            (event.start.month() === start.month()) &&
                            (event.start.date() === start.date())

                    }
                );

                return events.length > 0;
            }

            fcEventClick(event, jsEvent, view) {
                if (event.type === 'external') return;

                let adminBooking = new BBModel.Admin.Booking(event);
                if (adminBooking.$has('edit')) {
                    return this.editBooking(adminBooking);
                }
            }

            editBooking(booking) {
                let templateUrl, title;
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
                    success: (response) => {
                        if (typeof response === 'string') {
                            if (response === "move") {
                                let item_defaults = {person: booking.person_id, resource: booking.resource_id};

                                this.getCompanyPromise().then(
                                    (company) => {
                                        AdminMoveBookingPopup.open({
                                                item_defaults,
                                                company_id: company.id,
                                                booking_id: booking.id,
                                                success: (model) => {
                                                    return this.refreshBooking(booking);
                                                },
                                                fail: () => {
                                                    return this.refreshBooking(booking);
                                                }
                                            }
                                        );
                                    }
                                );
                            }
                        }

                        if (response.is_cancelled) {
                            return uiCalendarConfig.calendars[this.name].fullCalendar('removeEvents', [response.id]);
                        } else {
                            booking.title = this.getBookingTitle(booking);
                            return uiCalendarConfig.calendars[this.name].fullCalendar('updateEvent', booking);
                        }
                    }
                });
            }

            fcEventRender(event, element) {
                let adminBooking = new BBModel.Admin.Booking(event);

                let {type} = uiCalendarConfig.calendars[this.name].fullCalendar('getView');

                let service = _.findWhere(this.companyServices, {id: adminBooking.service_id});

                if (!this.model) {  // if not a single item view
                    let a, link;
                    if (type === "listDay") {
                        link = $bbug(element.children()[2]);
                        if (link) {
                            a = link.children()[0];
                            if (a) {
                                if (adminBooking.person_name && (!this.type || (this.type === "person"))) {
                                    a.innerHTML = adminBooking.person_name + " - " + a.innerHTML;
                                } else if (adminBooking.resource_name && (this.type === "resource")) {
                                    a.innerHTML = adminBooking.resource_name + " - " + a.innerHTML;
                                }
                            }
                        }
                    } else if ((type === "agendaWeek") || (type === "month")) {
                        link = $bbug(element.children()[0]);
                        if (link) {
                            a = link.children()[1];
                            if (a) {
                                if (adminBooking.person_name && (!this.type || (this.type === "person"))) {
                                    a.innerHTML = adminBooking.person_name + "<br/>" + a.innerHTML;
                                } else if (adminBooking.resource_name && (this.type === "resource")) {
                                    a.innerHTML = adminBooking.resource_name + "<br/>" + a.innerHTML;
                                }
                            }
                        }
                    }
                }
                if (service && (type !== "listDay")) {
                    element.css('background-color', service.color);
                    element.css('color', service.textColor);
                    element.css('border-color', service.textColor);
                }
                return element;
            }

            fcEventAfterRender(event, elements, view) {
                if ((event.rendering == null) || (event.rendering !== 'background')) {
                    return PrePostTime.apply(event, elements, view, this.$scope);
                }
            }

            fcEventAfterAllRender() {
                this.$scope.$emit('UICalendar:EventAfterAllRender');
            }

            fcViewRender(view, element) {
                let date = uiCalendarConfig.calendars[this.name].fullCalendar('getDate');
                let newDate = moment().tz(moment.tz.guess());
                newDate.set({
                    'year': parseInt(date.get('year')),
                    'month': parseInt(date.get('month')),
                    'date': parseInt(date.get('date')),
                    'hour': 0,
                    'minute': 0,
                    'second': 0
                });
                return this.currentDate = newDate.toDate();
            }

            fcEventResize(event, delta, revertFunc, jsEvent, ui, view) {
                //let adminBooking = new BBModel.Admin.Booking(event);
                event.duration = event.end.diff(event.start, 'minutes');
                return this.updateBooking(event);
            }

            fcLoading(isLoading, view) {
                this.calendarLoading = isLoading;
            }


        }

        return BbFullCalendar;
    }
);
