// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Day
*
* @description
* Representation of an Day Object
*
* @property {string} string_date The string date
* @property {date} date Second The date
*///

angular.module('BB.Models').factory("DayModel", ($q, BBModel, BaseModel, DayService) =>

  class Day extends BaseModel {

    constructor(data) {
      super(...arguments);
      this.string_date = this.date;
      this.date = moment(this.date);
    }

    /***
    * @ngdoc method
    * @name day
    * @methodOf BB.Models:Day
    * @description
    * Get day date
    *
    * @returns {date} The returned day
    */
    day() {
      return this.date.date();
    }

    /***
    * @ngdoc method
    * @name off
    * @methodOf BB.Models:Day
    * @description
    * Get off by month
    *
    * @returns {date} The returned off
    */
    off(month) {
      return this.date.month() !== month;
    }

    /***
    * @ngdoc method
    * @name class
    * @methodOf BB.Models:Day
    * @description
    * Get class in according of month
    *
    * @returns {string} The returned class
    */
    class(month) {
      let str = "";
      if (this.date.month() < month) {
        str += "off off-prev";
      }
      if (this.date.month() > month) {
        str += "off off-next";
      }
      if (this.spaces === 0) {
        str += " not-avail";
      }
      return str;
    }

    static $query(prms) {
      return DayService.query(prms);
    }
  }
);

