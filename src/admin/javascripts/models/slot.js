angular.module('BB.Models').factory("AdminSlotModel", ($q, BBModel, BaseModel, TimeSlotModel, SlotCollections, $window) =>

    class Admin_Slot extends TimeSlotModel {

        constructor(data) {
            super(data);
            this.title = this.full_describe;
            if (this.status === 0) {
                this.title = "Available";
            }
            this.datetime = moment(this.datetime);
            this.start = this.datetime;
            this.end = this.end_datetime;
            this.end = this.datetime.clone().add(this.duration, 'minutes');
            this.time = (this.start.hour() * 60) + this.start.minute();
            this.title = this.full_describe;
            //   @startEditable  = false
            //   @durationEditable  = false
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
            let existing = SlotCollections.find(params);
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
                        SlotCollections.delete(existing);
                    }
                    src.$flush('slots', params);
                }

                src.$get('slots', params).then(function (resource) {
                        if (resource.$has('slots')) {
                            return resource.$get('slots').then(function (slots) {
                                    let models = (Array.from(slots).map((b) => new BBModel.Admin.Slot(b)));
                                    let spaces = new $window.Collection.Slot(resource, models, params);
                                    SlotCollections.add(spaces);
                                    return defer.resolve(spaces);
                                }
                                , err => defer.reject(err));
                        } else {
                            let slot = new BBModel.Admin.Slot(resource);
                            return defer.resolve(slot);
                        }
                    }

                    , err => defer.reject(err));
            }
            return defer.promise;
        }
    }
);

