angular.module('BB.Services').factory("TimeService", ($q, BBModel, halClient, bbi18nOptions, CompanyStoreService, DateTimeUtilitiesService, bbTimeZone) => {

    return {
        query(prms) {

            let deferred = $q.defer();

            let start_date = null;
            let end_date = null;

            if (prms.date) {
                prms.start_date = prms.date;
            } else if (prms.cItem.date) {
                prms.start_date = prms.cItem.date.date;
            } else {
                deferred.reject("No date set");
                return deferred.promise;
            }

            ({start_date} = prms);

            if (prms.end_date) {
                ({end_date} = prms);
            }



            // Adjust time range based on UTC offset between company time zone and display time zone
            if ((bbTimeZone.getDisplayTimeZone() != null) && (bbTimeZone.getDisplayTimeZone() !== CompanyStoreService.time_zone)) {

                if (bbTimeZone.getCompanyUTCOffset() < bbTimeZone.getCompanyUTCOffset()) {
                    start_date = prms.start_date.clone().subtract(1, 'day');
                } else if ((bbTimeZone.getCompanyUTCOffset() > bbTimeZone.getDisplayUTCOffset()) && prms.end_date) {
                    end_date = prms.end_date.clone().add(1, 'day');
                }

                prms.time_zone = bbTimeZone.getDisplayTimeZone();
            }

            // If there was no duration passed in get the default duration off the
            // current item
            if (prms.duration == null) {
                if (prms.cItem && prms.cItem.duration) {
                    prms.duration = prms.cItem.duration;
                }
            }

            let {item_link} = prms;

            if (prms.cItem && prms.cItem.days_link && !item_link) {
                item_link = prms.cItem.days_link;
            }

            if (item_link) {

                let extra = {};
                extra.date = start_date.toISODate();
                if (prms.location) {
                    extra.location = prms.location;
                }
                if (prms.cItem.event_id) {
                    extra.event_id = prms.cItem.event_id;
                }
                if (prms.cItem.person && !prms.cItem.anyPerson() && !item_link.event_id && !extra.event_id) {
                    extra.person_id = prms.cItem.person.id;
                }
                if (prms.cItem.resource && !prms.cItem.anyResource() && !item_link.event_id && !extra.event_id) {
                    extra.resource_id = prms.cItem.resource.id;
                }
                if (end_date) {
                    extra.end_date = end_date.toISODate();
                }
                extra.duration = prms.duration;
                extra.person_group_id = prms.cItem.person_group_id;
                extra.num_resources = prms.num_resources;
                if (prms.time_zone) {
                    extra.time_zone = prms.time_zone;
                }
                if (prms.cItem.id) {
                    extra.ignore_booking = prms.cItem.id;
                }
                if (prms.people_ids) {
                    extra.people_ids = prms.people_ids;
                }
                if (prms.resource_ids) {
                    extra.resource_ids = prms.resource_ids;
                }

                if (extra.event_id) {
                    item_link = prms.company;
                } // if we have an event - the the company link - so we don't add in extra params

                item_link.$get('times', extra).then(results => {

                    let times;

                    if (results.$has('date_links')) {

                        // it's a date range - we're expecting several dates - lets build up a hash of dates
                        return results.$get('date_links').then(all_days => {

                            let all_days_def = [];

                            for (let day of Array.from(all_days)) {

                                (day => {

                                    // there's several days - get them all
                                    day.elink = $q.defer();
                                    all_days_def.push(day.elink.promise);

                                    if (day.$has('event_links')) {

                                        return day.$get('event_links').then(all_events => {
                                            times = this.merge_times(all_events, prms.cItem.service, prms.cItem, day.date);
                                            if (prms.available) {
                                                times = _.filter(times, t => t.avail >= prms.available);
                                            }
                                            return day.elink.resolve(times);
                                        });

                                    } else if (day.times) {

                                        times = this.merge_times([day], prms.cItem.service, prms.cItem, day.date);
                                        if (prms.available) {
                                            times = _.filter(times, t => t.avail >= prms.available);
                                        }
                                        return day.elink.resolve(times);
                                    }
                                })(day);
                            }

                            return $q.all(all_days_def).then(function (times) {

                                let date_times = {};

                                // build day/slot array ensuring slots are grouped by the display time zone
                                date_times = _.chain(times)
                                    .flatten()
                                    .sortBy(slot => slot.datetime.unix())
                                    .groupBy(slot => slot.datetime.toISODate())
                                    .value();

                                // add days back that don't have any availabiity and return originally requested range only
                                let newDateTimes = {};

                                let startDateClone = prms.start_date.clone();
                                while (startDateClone <= prms.end_date) {
                                    let dateISO = startDateClone.toISODate();
                                    newDateTimes[dateISO] = date_times[dateISO] ? date_times[dateISO] : [];
                                    startDateClone = startDateClone.clone().add(1, 'day');
                                }

                                return deferred.resolve(newDateTimes);
                            });
                        });

                    } else if (results.$has('event_links')) {

                        // single day - but a list of bookable events
                        return results.$get('event_links').then(all_events => {
                            times = this.merge_times(all_events, prms.cItem.service, prms.cItem, prms.start_date);
                            if (prms.available) {
                                times = _.filter(times, t => t.avail >= prms.available);
                            }

                            // returns array of time slots
                            return deferred.resolve(times);
                        });

                    } else if (results.times) {
                        times = this.merge_times([results], prms.cItem.service, prms.cItem, prms.start_date);
                        if (prms.available) {
                            times = _.filter(times, t => t.avail >= prms.available);
                        }

                        // returns array of time slots
                        return deferred.resolve(times);
                    }
                }
                , err => deferred.reject(err));

            } else {
                deferred.reject("No day data");
            }

            return deferred.promise;
        },


        // query a set of basket items for the same time data
        queryItems(prms) {

            let defer = $q.defer();

            let pslots = [];

            for (let item of Array.from(prms.items)) {
                pslots.push(this.query({
                    company: prms.company,
                    cItem: item,
                    date: prms.start_date,
                    end_date: prms.end_date,
                    client: prms.client,
                    available: 1
                }));
            }

            $q.all(pslots).then(res => defer.resolve(res)
                , err => defer.reject());

            return defer.promise;
        },


        merge_times(all_events, service, item, date) {

            let i;
            if (!all_events || (all_events.length === 0)) {
                return [];
            }

            all_events = _.shuffle(all_events);
            let sorted_times = [];
            for (let ev of Array.from(all_events)) {
                if (ev.times) {
                    for (i of Array.from(ev.times)) {
                        // set it not set, currently unavailable, or randomly based on the number of events
                        if (!sorted_times[i.time] || (sorted_times[i.time].avail === 0) || ((Math.floor(Math.random() * all_events.length) === 0) && (i.avail > 0))) {
                            i.event_id = ev.event_id;
                            sorted_times[i.time] = i;
                        }
                    }
                    // if we have an item - which an already booked item - make sure that it's the list of time slots we can select - i.e. that we can select the current slot
                    if (item.held) {
                        this.checkCurrentItem(item.held, sorted_times, ev);
                    }
                    this.checkCurrentItem(item, sorted_times, ev);
                }
            }

            let times = [];

            for (i of Array.from(sorted_times)) {
                if (i) {

                    // add datetime if not provided by the API (versions < 1.5.4-1 )
                    if (!i.datetime) {
                        i.datetime = DateTimeUtilitiesService.convertTimeToMoment(moment(date), i.time);
                    }

                    times.push(new BBModel.TimeSlot(i, service));
                }
            }

            return times;
        },


        checkCurrentItem(item, sorted_times, ev) {
            if (item && item.id && (item.event_id === ev.event_id) && item.time && !sorted_times[item.time.time] && item.date && (item.date.date.toISODate() === ev.date)) {
                // calculate the correct datetime for time slot
                item.time.datetime = DateTimeUtilitiesService.convertTimeToMoment(item.date.date, item.time.time);
                sorted_times[item.time.time] = item.time;
                // remote this entry from the cache - just in case - we know it has a held item in it so lets just not keep it in case that goes later!
                return halClient.clearCache(ev.$href("self"));
            } else if (item && item.id && (item.event_id === ev.event_id) && item.time && sorted_times[item.time.time] && item.date && (item.date.date.toISODate() === ev.date)) {
                return sorted_times[item.time.time].avail = 1;
            }
        }
    };

});
