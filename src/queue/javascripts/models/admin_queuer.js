// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("AdminQueuerModel", ($q, BaseModel, AdminQueuerService) =>

  class Admin_Queuer extends BaseModel {

    constructor(data) {
      super(data);
      this.start = moment.parseZone(this.start);
      this.due = moment.parseZone(this.due);
      this.end = moment(this.start).add(this.duration, 'minutes');
    }


    remaining() {
      let d = this.due.diff(moment.utc(), 'seconds');
      this.remaining_signed = Math.abs(d);
      return this.remaining_unsigned = d;
    }


    startServing(person) {
      let defer = $q.defer();
      if (this.$has('start_serving')) {
        person.$flush('self');
        this.$post('start_serving', {person_id: person.id}).then(q => {
          person.$get('self').then(p => person.updateModel(p));
          this.updateModel(q);
          return defer.resolve(this);
        }
        , err => {
          return defer.reject(err);
        }
        );
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
        }
        , err => {
          return defer.reject(err);
        }
        );
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
      }
      , err => defer.reject(err));
      return defer.promise;
    }

    static $query(params) {
      return AdminQueuerService.query(params);
    }
  }
);

