// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("Member.BookingModel", ($q, $window, $bbug,
  MemberBookingService, BBModel, BaseModel) =>

  class Member_Booking extends BaseModel {
    constructor(data) {
      super(data);

      this.datetime = moment.parseZone(this.datetime);
      if (this.time_zone) { this.datetime.tz(this.time_zone); }

      this.end_datetime = moment.parseZone(this.end_datetime);
      if (this.time_zone) { this.end_datetime.tz(this.time_zone); }

      this.min_cancellation_time = moment(this.min_cancellation_time);
      this.min_cancellation_hours = this.datetime.diff(this.min_cancellation_time, 'hours');
    }

    icalLink() {
      return this._data.$href('ical');
    }

    webcalLink() {
      return this._data.$href('ical');
    }

    gcalLink() {
      return this._data.$href('gcal');
    }

    getGroup() {
      if (this.group) { return this.group; }
      if (this._data.$has('event_groups')) {
        return this._data.$get('event_groups').then(group => {
          this.group = group;
          return this.group;
        }
        );
      }
    }

    getColour() {
      if (this.getGroup()) {
        return this.getGroup().colour;
      } else {
        return "#FFFFFF";
      }
    }

    getCompany() {
      if (this.company) { return this.company; }
      if (this.$has('company')) {
        return this._data.$get('company').then(company => {
          this.company = new BBModel.Company(company);
          return this.company;
        }
        );
      }
    }

    getAnswers() {
      let defer = $q.defer();
      if (this.answers) { defer.resolve(this.answers); }
      if (this._data.$has('answers')) {
        this._data.$get('answers').then(answers => {
          this.answers = (Array.from(answers).map((a) => new BBModel.Answer(a)));
          return defer.resolve(this.answers);
        }
        );
      } else {
        defer.resolve([]);
      }
      return defer.promise;
    }

    printed_price() {
      if ((parseFloat(this.price) % 1) === 0) { return `£${this.price}`; }
      return $window.sprintf("£%.2f", parseFloat(this.price));
    }

    $getMember() {
      let defer = $q.defer();
      if (this.member) { defer.resolve(this.member); }
      if (this._data.$has('member')) {
        this._data.$get('member').then(member => {
          this.member = new BBModel.Member.Member(member);
          return defer.resolve(this.member);
        }
        );
      }
      return defer.promise;
    }

    canCancel() {
      return moment(this.min_cancellation_time).isAfter(moment());
    }

    canMove() {
      return this.canCancel();
    }

    $update() {
      return MemberBookingService.update(this);
    }

    static $query(member, params) {
      return MemberBookingService.query(member, params);
    }

    static $cancel(member, booking) {
      return MemberBookingService.cancel(member, booking);
    }

    static $update(booking) {
      return MemberBookingService.update(booking);
    }

    static $flush(member, params) {
      return MemberBookingService.flush(member, params);
    }
  }
);
