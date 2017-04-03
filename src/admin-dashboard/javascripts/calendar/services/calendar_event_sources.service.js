/*
 * @ngdoc service
 * @name BBAdminDashboard.calendar.services.service:CalendarEventSources
 *
 * @description
 * This services exposes methods to get all event-type information to be shown in the calendar
 */
angular
    .module('BBAdminDashboard.calendar.services')
    .service('CalendarEventSources', function (AdminScheduleService, BBModel, $q, TitleAssembler, $translate, AdminCalendarOptions, $rootScope, bbTimeZone) {

        'ngInject';

        let bookingBelongsToSelectedResources = function (resources, booking) {
            let belongs = false;
            _.each(resources, function (asset) {
                if (_.contains(booking.resourceIds, asset.id)) {
                    return belongs = true;
                }
            });
            return belongs;
        };

        /*
         * @ngdoc method
         * @name getBookingsAndBlocks
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Returns all bookings and blocks for a certain period of time,
         * filtered by a list of resources if one is provided through the options
         *
         * @param {object} company  The company to be queried for bookings and blocks
         * @param {Moment} start    Moment object containing the start of the requested period
         * @param {Moment} end      Moment object containing the end of the requested period
         * @param {object} options  Object which contains usefull flags and params
         The relevant ones for this method are:
         - {boolean} noCache              skips the cache
         - {boolean} showAll              skip the filter by resource filter
         - {array}   selectedResources    array of selected resource to filter against
         - {string}  labelAssembler       the pattern to use for bookings (see TitleAssembler)
         - {string}  blockLabelAssembler  the pattern to use for blocks (see TitleAssembler)

         * @returns {Promise} Promise which once resolved returns an array of bookings and blocks
         */
        let getBookingsAndBlocks = function (company, start, end, options) {
            if (options == null) {
                options = {};
            }
            let deferred = $q.defer();

            let params = {
                company,
                start_date: start.format('YYYY-MM-DD'),
                end_date: end.format('YYYY-MM-DD'),
                skip_cache: (options.noCache != null) && options.noCache ? true : false
            };

            BBModel.Admin.Booking.$query(params).then(function (bookings) {
                    let filteredBookings = [];

                    for (let booking of Array.from(bookings.items)) {

                        booking.service_name = $translate.instant(booking.service_name);

                        booking.resourceIds = [];
                        if (booking.person_id != null) {
                            booking.resourceIds.push(booking.person_id + '_p');
                        }
                        if (booking.resource_id != null) {
                            booking.resourceIds.push(booking.resource_id + '_r');
                        }

                        // Add to returned results is no specific resources where requested
                        // or event belongs to one of the selected resources
                        if ((options.showAll == null) || ((options.showAll != null) && options.showAll) || bookingBelongsToSelectedResources(options.selectedResources, booking)) {
                            booking.useFullTime();
                            if (booking.$has('edit')) {
                                booking.startEditable = true;
                            }

                            if ((booking.status !== 3) && (options.labelAssembler != null)) {
                                booking.title = TitleAssembler.getTitle(booking, options.labelAssembler);

                            } else if ((booking.status === 3) && (options.blockLabelAssembler != null)) {
                                booking.title = TitleAssembler.getTitle(booking, options.blockLabelAssembler);
                            }

                            //# if we're limiting to peopel or resoures - check this is correct
                            if (!options.type || ((options.type === "resource") && booking.resource_id ) || ((options.type === "person") && booking.person_id )) {
                                filteredBookings.push(booking);
                            }
                        }
                    }

                    return deferred.resolve(filteredBookings);
                }

                , err => deferred.reject(err));

            return deferred.promise;
        };

        /*
         * @ngdoc method
         * @name getExternalBookings
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Returns all external bookings for a certain period of time
         *
         * @param {object} company  The company to be queried for bookings and blocks
         * @param {Moment} start    Moment object containing the start of the requested period
         * @param {Moment} end      Moment object containing the end of the requested period
         * @param {object} options  Object which contains usefull flags and params
         The relevant ones for this method are:
         - {string}  externalLabelAssembler  the pattern to use for the title (see TitleAssembler)

         * @returns {Promise} Promise which once resolved returns an array of bookings
         */
        let getExternalBookings = function (company, start, end, options) {
            if (options == null) {
                options = {};
            }
            let deferred = $q.defer();
            if (company.$has('external_bookings')) {
                let params = {
                    start: start.format(),
                    end: end.format(),
                    no_cache: (options.noCache != null) && options.noCache ? true : false
                };
                company.$get('external_bookings', params).then(function (collection) {
                        let bookings = collection.external_bookings;
                        if (bookings) {
                            for (let booking of Array.from(bookings)) {
                                booking.resourceIds = [];
                                if (booking.person_id != null) {
                                    booking.resourceIds.push(booking.person_id + '_p');
                                }

                                if (booking.resource_id != null) {
                                    booking.resourceIds.push(booking.resource_id + '_r');
                                }

                                if (!booking.title) {
                                    booking.title = "Blocked";
                                }
                                if (options.externalLabelAssembler != null) {
                                    booking.title = TitleAssembler.getTitle(booking, options.externalLabelAssembler);
                                }

                                booking.className = 'status_external';
                                booking.type = 'external';
                                booking.editable = false;
                                booking.startEditable = false;
                                booking.durationEditable = false;
                                booking.resourceEditable = false;
                            }

                            return deferred.resolve(bookings);
                        } else {
                            return deferred.resolve([]);
                        }
                    }
                    , err => deferred.reject(err));
            } else {
                deferred.resolve([]);
            }
            return deferred.promise;
        };

        /*
         * @ngdoc method
         * @name getAvailabilityBackground
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Returns all availability for a certain period of time,
         * filtered by a list of resources if one is provided through the options,
         * and grouped per calendar day if in week or month view
         *
         * @param {object} company  The company to be queried for bookings and blocks
         * @param {Moment} start    Moment object containing the start of the requested period
         * @param {Moment} end      Moment object containing the end of the requested period
         * @param {object} options  Object which contains usefull flags and params
         The relevant ones for this method are:
         - {boolean} noCache              skips the cache
         - {boolean} showAll              skip the filter by resource filter
         - {array}   selectedResources    array of selected resource to filter against
         - {string}  calendarView         identifies which view the calendar is curently displaying (enum: 'timelineDay', 'agendaWeek', 'month')

         * @returns {Promise} Promise which once resolved returns an array of availability background events
         */
        let getAvailabilityBackground = function (company, start, end, options) {
            if (options == null) {
                options = {};
            }
            let deferred = $q.defer();


            AdminScheduleService.getAssetsScheduleEvents(company, start, end, !options.showAll, options.selectedResources).then(function (availabilities) {

                    if ((AdminCalendarOptions.minTime == null) || (AdminCalendarOptions.maxTime == null)) {
                        setCalendarAvailabilityRange(availabilities);
                    }

                    if (options.calendarView === 'timelineDay') {
                        return deferred.resolve(availabilities);
                    } else {
                        let overAllAvailabilities = [];


                        for (let avail of Array.from(availabilities)) {
                            avail.unix_start = moment(avail.start).unix();
                            avail.unix_end = moment(avail.end).unix();
                            avail.delete_me = false;
                        }


                        let sorted = _.sortBy(availabilities, x => moment(x.start).unix());

                        let id = 0;
                        let test_id = 1;

                        while (test_id < (sorted.length)) {
                            let src = sorted[id];
                            let test = sorted[test_id];
                            //console.log(id, test_id, src)
                            if (!src.delete_me) {
                                if ((test.unix_end > src.unix_end) && (test.unix_start < src.unix_end)) {
                                    src.end = test.end;
                                    src.unix_end = test.unix_end;
                                    test.delete_me = true;
                                    test_id += 1;
                                } else if (test.unix_end <= src.unix_end) {
                                    // it's inside - just delete it
                                    test.delete_me = true;
                                    test_id += 1;
                                } else {
                                    id += 1;
                                    test_id += 1;
                                }
                            } else {
                                id += 1;
                                test_id = id + 1;
                            }
                        }


                        for (let availability of Array.from(sorted)) {
                            if (!availability.delete_me) {
                                overAllAvailabilities.push({
                                    start: availability.start,
                                    end: availability.end,
                                    rendering: "background",
                                    title: `Joined availability ${moment(availability.start).format('YYYY-MM-DD')}`,
                                    allDay: options.calendarView === 'month' ? true : false
                                });
                            }
                        }

                        //console.log overAllAvailabilities


                        return deferred.resolve(overAllAvailabilities);
                    }
                }
                , err => deferred.reject(err));

            return deferred.promise;
        };


        /**
         * @ngdoc method
         * @name setCalendarAvailabilityRange
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Sets AdminCalendarOptions availability range to the minTime and maxTime from all schedules
         *
         * @param {array} availabilities  The availabilities to get the min/max time from
         */
        var setCalendarAvailabilityRange = function (availabilities) {
            let maxTime, minTime;
            if (availabilities.length === 0) {
                return;
            }
            // set minTime and maxTime to first availabilty and loop through to get earliest start and latest end
            for (let index = 0; index < availabilities.length; index++) {
                let availability = availabilities[index];
                if (availability.start.isBefore(minTime) || (index === 0)) {
                    minTime = availability.start;
                }
                if (availability.end.isAfter(maxTime) || (index === 0)) {
                    maxTime = availability.end;
                }
            }

            minTime = bbTimeZone.convertToCompanyTz(minTime);
            maxTime = bbTimeZone.convertToCompanyTz(maxTime);

            // store on AdminCalendarOptions object to read from in resourceCalendar controller prepareUiCalOptions method
            AdminCalendarOptions.minTime = minTime.format('HH:mm');
            AdminCalendarOptions.maxTime = maxTime.format('HH:mm');

            guardMidnightFormat(minTime, maxTime);

            $rootScope.$broadcast('CalendarEventSources:timeRangeChanged');

        };


        /**
         * @ngdoc method
         * @name guardMidnightFormat
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Formats maxTime from 00:00 to 24:00 when using 24 hour availability
         *
         * @param {Moment} minTime Moment object containing minimum availability time
         * @param {Moment} maxTime Moment object containing maximum availability time
         */
        var guardMidnightFormat = function (minTime, maxTime) {
            if (!minTime.isSame(maxTime, 'day') && (AdminCalendarOptions.maxTime === '00:00')) {
                AdminCalendarOptions.maxTime = '24:00';
            }
        };


        /**
         * @ngdoc method
         * @name getAllCalendarEntries
         * @methodOf BBAdminDashboard.calendar.services.service:CalendarEventSources
         * @description
         * Returns all event type information to be displayed in the calendar
         *
         * @param {object} company  The company to be queried for bookings and blocks
         * @param {Moment} start    Moment object containing the start of the requested period
         * @param {Moment} end      Moment object containing the end of the requested period
         * @param {object} options  Object which contains usefull flags and params (see above methodds for details)
         *
         * @returns {Promise} Promise which once resolved returns an array of availability background events
         */
        let getAllCalendarEntries = function (company, start, end, options) {
            if (options == null) {
                options = {};
            }
            let deferred = $q.defer();

            let promises = [
                getBookingsAndBlocks(company, start, end, options),
                getExternalBookings(company, start, end, options),
                getAvailabilityBackground(company, start, end, options),
            ];

            $q.all(promises).then(function (resolutions) {
                    let allResults = [];
                    angular.forEach(resolutions, (results, index) => allResults = allResults.concat(results));

                    return deferred.resolve(allResults);
                }
                , err => deferred.reject(err));

            return deferred.promise;
        };

        return {
            getBookingsAndBlocks,
            getExternalBookings,
            getAvailabilityBackground,
            getAllCalendarEntries
        };
    });
