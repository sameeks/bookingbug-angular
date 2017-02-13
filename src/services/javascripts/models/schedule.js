/***
* @ngdoc service
* @name BB.Models:AdminSchedule
*
* @description
* Representation of an Schedule Object
*
* @property {integer} id Schedule id
* @property {string} rules Schedule rules
* @property {string} name Schedule name
* @property {integer} company_id The company id
* @property {date} duration The schedule duration
*///

angular.module('BB.Models').factory("AdminScheduleModel", ($q, AdminScheduleService, BBModel, BaseModel, ScheduleRules) =>

  class Admin_Schedule extends BaseModel {

    constructor(data) {
      super(data);
    }

    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminSchedule
    * @description
    * Get post data
    *
    * @returns {array} Returns data.
    */
    getPostData() {
      let data = {};
      data.id = this.id;
      data.rules = this.rules;
      data.name = this.name;
      data.company_id = this.company_id;
      data.duration = this.duration;
      return data;
    }

    static $query(params) {
      return AdminScheduleService.query(params);
    }

    static $delete(schedule) {
      return AdminScheduleService.delete(schedule);
    }

    static $update(schedule) {
      return AdminScheduleService.update(schedule);
    }
  }
);

