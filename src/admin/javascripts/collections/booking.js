// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
window.Collection.Booking = class Booking extends window.Collection.Base {

  checkItem(item) {
    return super.checkItem(...arguments);
  }

  matchesParams(item) {
    if ((this.params.start_date != null) && item.start) {
      if (this.start_date == null) { this.start_date = moment(this.params.start_date); }
      if (this.start_date.isAfter(item.start)) { return false; }
    }
    if ((this.params.end_date != null) && item.start) {
      if (this.end_date == null) { this.end_date = moment(this.params.end_date); }
      if (this.end_date.isBefore(item.start.clone().startOf('day'))) { return false; }
    }
    if (!this.params.include_cancelled && item.is_cancelled) { return false; }
    return true;
  }
};


angular.module('BB.Services').provider("BookingCollections", () =>
  ({
    $get() {
      return new  window.BaseCollections();
    }
  })
);

