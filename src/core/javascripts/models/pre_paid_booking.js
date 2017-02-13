/***
* @ngdoc service
* @name BB.Models:PrePaidBooking
*
* @description
* Representation of an PrePaidBooking Object
*///


angular.module('BB.Models').factory("PrePaidBookingModel", ($q, BBModel, BaseModel) =>

  class PrePaidBooking extends BaseModel {

    constructor(data) {
      super(data);

      if (this.book_by) { this.book_by  = moment(this.book_by); }
      if (this.use_by) { this.use_by   = moment(this.use_by); }
      if (this.use_from) { this.use_from = moment(this.use_from); }
      // TODO remove once api updated to not return expired prepaid bookings
      this.expired = (this.book_by && moment().isAfter(this.book_by, 'day')) || (this.use_by && moment().isAfter(this.use_by, 'day')) || false;
    }


    checkValidity(item) {
      if (this.service_id && item.service_id && (this.service_id !== item.service_id)) {
        return false;
      } else if (this.resource_id && item.resource_id && (this.resource_id !== item.resource_id)) {
        return false;
      } else if (this.person_id && item.person_id && (this.person_id !== item.person_id)) {
        return false;
      } else {
        return true;
      }
    }
  }
);

