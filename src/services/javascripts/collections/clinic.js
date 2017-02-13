window.Collection.Clinic = class Clinic extends window.Collection.Base {

  checkItem(item) {
    return super.checkItem(...arguments);
  }


  matchesParams(item) {
    if (this.params.start_time) {
      if (!this.start_time) { this.start_time = moment(this.params.start_time); }
      if (this.start_time.isAfter(item.start_time)) { return false; }
    }
    if (this.params.end_time) {
      if (!this.end_time) { this.end_time = moment(this.params.end_time); }
      if (this.end_time.isBefore(item.end_time)) { return false; }
    }
    if (this.params.start_date) {
      if (!this.start_date) { this.start_date = moment(this.params.start_date); }
      if (this.start_date.isAfter(item.start_date)) { return false; }
    }
    if (this.params.end_date) {
      if (!this.end_date) { this.end_date = moment(this.params.end_date); }
      if (this.end_date.isBefore(item.end_date)) { return false; }
    }
    return true;
  }
};


angular.module('BBAdmin.Services').provider("ClinicCollections", () =>

  ({
    $get() {
      return new  window.BaseCollections();
    }
  })
);

