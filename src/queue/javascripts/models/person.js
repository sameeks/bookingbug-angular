angular.module('BB.Models').factory("AdminQueuerPersonModel", ($q, AdminPersonService, BBModel,
    BaseModel, PersonModel) =>

    class Admin_Person extends PersonModel {

        constructor(data) {
            super(data);
            if (!this.queuing_disabled) {
                this.setCurrentCustomer();
                if (this.attendance_status === 2 || this.attendance_status === 4) {
                    this.updateEstimatedReturn();
                }
            }
        }

        /***
         * @ngdoc method
         * @name setCurrentCustomer
         * @methodOf BB.Models:AdminPerson
         * @description
         * Set current customer
         *
         * @returns {Promise} Returns a promise that rezolve the current customer
         */
        setCurrentCustomer() {
            let defer = $q.defer();
            if (this.$has('queuer')) {
                this.$get('queuer').then(queuer => {
                    this.serving = new BBModel.Admin.Queuer(queuer);
                    return defer.resolve(this.serving);
                }, err => defer.reject(err));
            } else {
                defer.resolve();
            }
            return defer.promise;
        }

        startServing() {
            let defer = $q.defer();
            if (this.$has('start_serving')) {
                this.$flush('self');
                this.$post('start_serving', {this: this.id}).then(q => {
                    this.$get('self').then(p => this.updateModel(p));
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
                    if (!this.$has('queuer')) this.serving = null;
                    return defer.resolve(this);
                }, err => {
                    return defer.reject(err);
                });
            } else {
                defer.reject('finish_serving link not available');
            }
            return defer.promise;
        }

        setAttendance(status, duration) {
            let defer = $q.defer();
            this.$put('attendance', {}, {status, estimated_duration: duration}).then(response => {
                this.updateModel(response);
                if (status === 2) {
                    this.updateEstimatedReturn(duration);
                }
                if (!this.$has('queuer')) this.serving = null;
                defer.resolve(this);
            }, err => {
                defer.reject(err);
            });
            return defer.promise;
        }

        updateEstimatedReturn(estimate) {
            let start = this.attendance_started;
            if (!estimate) estimate = this.attendance_estimate;
            if (start && estimate) {
                this.estimated_return = moment(start).add(estimate, 'minutes').format('LT');
            }
        }
    }
);

// angular.module('BBQueue').run(function($injector, BBModel) {
//     BBModel['Admin']['Person'] = $injector.get("AdminQueuerPersonModel");
// });
