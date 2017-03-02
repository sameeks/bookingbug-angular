angular.module('BB.Models').factory("AdminBookingModel", ($q, BBModel,
                                                          BaseModel, BookingCollections, $window) =>

        class Admin_Booking extends BaseModel {

            constructor(data) {
                super(...arguments);
                this.datetime = moment(this.datetime);
                this.start = this.datetime;
                this.end = this.end_datetime;
                if (!this.end) {
                    this.end = this.datetime.clone().add(this.duration, 'minutes');
                }
                this.title = this.full_describe;
                this.time = (this.start.hour() * 60) + this.start.minute();
//      @startEditable  = false
//      @durationEditable  = false
                // set to all day if it's a 24 hours span
                this.allDay = false;
                if (this.duration_span && (this.duration_span === 86400)) {
                    this.allDay = true;
                }
                if (this.status === 3) {
                    this.startEditable = true;
                    this.durationEditable = true;
                    this.className = "status_blocked";
                } else if (this.status === 4) {
                    this.className = "status_booked";
                } else if (this.status === 0) {
                    this.className = "status_available";
                }
                if (this.multi_status) {
                    for (let k in this.multi_status) {
                        this.className += ` status_${k}`;
                    }
                }
            }


            useFullTime() {
                this.using_full_time = true;
                if (this.pre_time) {
                    this.start = this.datetime.clone().subtract(this.pre_time, 'minutes');
                }
                if (this.post_time) {
                    return this.end = this.datetime.clone().add(this.duration + this.post_time, 'minutes');
                }
            }

            getPostData() {
                let data = {};
                if (this.date && this.time) {
                    data.date = this.date.date.toISODate();
                    data.time = this.time.time;
                    if (this.time.event_id) {
                        data.event_id = this.time.event_id;
                    } else if (this.time.event_ids) { // what's this about?
                        data.event_ids = this.time.event_ids;
                    }
                } else {
                    this.datetime = this.start.clone();
                    if (this.using_full_time) {
                        // we need to make sure if @start has changed - that we're adjusting for a possible pre-time
                        this.datetime.add(this.pre_time, 'minutes');
                    }
                    data.date = this.datetime.format("YYYY-MM-DD");
                    data.time = (this.datetime.hour() * 60) + this.datetime.minute();
                }
                data.duration = this.duration;
                data.id = this.id;
                data.pre_time = this.pre_time;
                data.post_time = this.post_time;
                data.person_id = this.person_id;
                data.resource_id = this.resource_id;
                data.child_client_ids = this.child_client_ids;
                data.people_ids = this.people_ids;
                if (this.questions) {
                    data.questions = (Array.from(this.questions).map((q) => q.getPostData()));
                }
                return data;
            }

            hasStatus(status) {
                return (this.multi_status[status] != null);
            }

            statusTime(status) {
                if (this.multi_status[status]) {
                    return moment(this.multi_status[status]);
                } else {
                    return null;
                }
            }

            sinceStatus(status) {
                let s = this.statusTime(status);
                if (!s) {
                    return 0;
                }
                return Math.floor((moment().unix() - s.unix()) / 60);
            }

            sinceStart(options) {
                let s;
                let start = this.datetime.unix();
                if (!options) {
                    return Math.floor((moment().unix() - start) / 60);
                }
                if (options.later) {
                    s = this.statusTime(options.later).unix();
                    if (s > start) {
                        return Math.floor((moment().unix() - s) / 60);
                    }
                }
                if (options.earlier) {
                    s = this.statusTime(options.earlier).unix();
                    if (s < start) {
                        return Math.floor((moment().unix() - s) / 60);
                    }
                }
                return Math.floor((moment().unix() - start) / 60);
            }

            answer(q) {
                if (this.answers_summary) {
                    for (let a of Array.from(this.answers_summary)) {
                        if (a.name === q) {
                            return a.answer;
                        }
                    }
                }
                return null;
            }

            $update(data) {
                let defer = $q.defer();
                if (data) {
                    data.datetime = moment(data.datetime);
                    data.datetime.tz();
                    data.datetime = data.datetime.format();
                }
                if (!data) {
                    data = this.getPostData();
                }
                this.$put('self', {}, data).then(res => {
                        this.constructor(res);
                        if (this.using_full_time) {
                            this.useFullTime();
                        }
                        BookingCollections.checkItems(this);
                        return defer.resolve(this);
                    }
                    , err => defer.reject(err));
                return defer.promise;
            }

            $refetch() {
                let defer = $q.defer();
                this.$flush('self');
                this.$get('self').then(res => {
                        this.constructor(res);
                        if (this.using_full_time) {
                            this.useFullTime();
                        }
                        BookingCollections.checkItems(this);
                        return defer.resolve(this);
                    }
                    , err => defer.reject(err));
                return defer.promise;
            }

            static $query(params) {
                let company;
                if (params.slot) {
                    params.slot_id = params.slot.id;
                }
                if (params.date) {
                    params.start_date = params.date;
                    params.end_date = params.date;
                }
                if (params.company) {
                    ({company} = params);
                    delete params.company;
                    params.company_id = company.id;
                }
                if (params.per_page == null) {
                    params.per_page = 1024;
                }
                if (params.include_cancelled == null) {
                    params.include_cancelled = false;
                }
                let defer = $q.defer();
                let existing = BookingCollections.find(params);
                if (existing && !params.skip_cache) {
                    defer.resolve(existing);
                } else {
                    let src = company;
                    if (!src) {
                        ({src} = params);
                    }
                    if (params.src) {
                        delete params.src;
                    }
                    if (params.skip_cache) {
                        if (existing) {
                            BookingCollections.delete(existing);
                        }
                        src.$flush('bookings', params);
                    }

                    src.$get('bookings', params).then(function (resource) {
                            if (resource.$has('bookings')) {
                                return resource.$get('bookings').then(function (bookings) {
                                        let models = (Array.from(bookings).map((b) => new BBModel.Admin.Booking(b)));
                                        let spaces = new $window.Collection.Booking(resource, models, params);
                                        BookingCollections.add(spaces);
                                        return defer.resolve(spaces);
                                    }
                                    , err => defer.reject(err));
                            } else {
                                let booking = new BBModel.Admin.Booking(resource);
                                return defer.resolve(booking);
                            }
                        }

                        , err => defer.reject(err));
                }
                return defer.promise;
            }
        }
);

