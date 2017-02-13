// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("AdminCompanyModel", (CompanyModel, AdminCompanyService, BookingCollections, $q, BBModel) =>

  class Admin_Company extends CompanyModel {

    constructor(data) {
      super(data);
    }

    getBooking(id) {
      let defer = $q.defer();
      this.$get('bookings', {id}).then(function(booking) {
        let model = new BBModel.Admin.Booking(booking);
        BookingCollections.checkItems(model);
        return defer.resolve(model);
      }
      , err => defer.reject(err));
      return defer.promise;
    }

    static $query(params) {
      return AdminCompanyService.query(params);
    }
  }
);

