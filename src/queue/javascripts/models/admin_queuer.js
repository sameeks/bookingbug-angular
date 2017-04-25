angular.module('BB.Models').factory("AdminQueuerModel", function ($q, BBModel, BaseModel) {

    return class Admin_Queuer extends BaseModel {

        constructor(data) {
            super(data);
            this.start = moment.parseZone(this.start);
            this.due = moment.parseZone(this.due);
            this.end = moment(this.start).add(this.duration, 'minutes');
            this.created_at = moment.parseZone(this.created_at);
        }

        remaining() {
            let d = this.due.diff(moment.utc(), 'seconds');
            this.remaining_unsigned = Math.abs(d);
            return this.remaining_signed = d;
        }

        getName() {
            let str = "";
            if (this.first_name) {
                str += this.first_name;
            }
            if ((str.length > 0) && this.last_name) {
                str += " ";
            }
            if (this.last_name) {
                str += this.last_name;
            }
            return str;
        }

        /***
         * @ngdoc method
         * @name fullMobile
         * @methodOf BB.Models:Address
         * @description
         * Full mobile phone number of the client
         *
         * @returns {object} The returned full mobile number
         */
        fullMobile() {
            if (!this.mobile) {
                return;
            }
            if (!this.mobile_prefix) {
                return this.mobile;
            }
            return `+${this.mobile_prefix}${this.mobile.substr(0, 1) === '0' ? this.mobile.substr(1) : this.mobile}`;
        }

        startServing(person) {
            let defer = $q.defer();
            if (this.$has('start_serving')) {
                console.log('start serving url ', this.$href('start_serving'));
                person.$flush('self');
                this.$post('start_serving', {person_id: person.id}).then(q => {
                    person.$get('self').then(p => person.updateModel(p));
                    this.updateModel(q);
                    return defer.resolve(this);
                }, err => {
                    return defer.reject(err);
                });
            } else {
                defer.reject('start_serving link not available');
            }
            return defer.promise;
        }

        finishServing() {
            let defer = $q.defer();
            if (this.$has('finish_serving')) {
                this.$post('finish_serving').then(q => {
                    this.updateModel(q);
                    return defer.resolve(this);
                }, err => {
                    return defer.reject(err);
                });
            } else {
                defer.reject('finish_serving link not available');
            }
            return defer.promise;
        }

        extendAppointment(minutes) {
            let new_duration;
            let defer = $q.defer();
            if (this.end.isBefore(moment())) {
                let d = moment.duration(moment().diff(this.start));
                new_duration = d.as('minutes') + minutes;
            } else {
                new_duration = this.duration + minutes;
            }
            this.$put('self', {}, {duration: new_duration}).then(q => {
                this.updateModel(q);
                this.end = moment(this.start).add(this.duration, 'minutes');
                return defer.resolve(this);
            }, err => defer.reject(err));
            return defer.promise;
        }

        $refetch() {
            let defer = $q.defer();
            this.$flush('self');
            this.$get('self').then(res => {
                this.constructor(res);
                return defer.resolve(this);
            }, err => defer.reject(err));
            return defer.promise;
        }


        $delete() {
            let defer = $q.defer();
            this.$flush('self');
            this.$del('self').then(res => {
                this.constructor(res);
                return defer.resolve(this);
            }, err => defer.reject(err));
            return defer.promise;
        }
    };
});
