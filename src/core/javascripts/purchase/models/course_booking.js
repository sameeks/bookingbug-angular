// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("Purchase.CourseBookingModel", ($q, BBModel, BaseModel) =>

  class Purchase_Course_Booking extends BaseModel {
    constructor(data) {
      super(data);
    }

    getBookings() {
      let defer = $q.defer();
      if (this.bookings) { defer.resolve(this.bookings); }
      if (this._data.$has('bookings')) {
        this._data.$get('bookings').then(bookings => {
          this.bookings = ((() => {
            let result = [];
            for (let b of Array.from(bookings)) {               result.push(new BBModel.Purchase.Booking(b));
            }
            return result;
          })());
          this.bookings.sort((a, b) => a.datetime.unix() - b.datetime.unix());
          return defer.resolve(this.bookings);
        }
        );
      } else {
        this.bookings = [];
        defer.resolve(this.bookings);
      }
      return defer.promise;
    }
  }
);

