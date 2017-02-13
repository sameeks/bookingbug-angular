/***
* @ngdoc service
* @name BB.Models:AdminClinic
*
* @description
* Representation of an Clinic Object
*
* @property {string} setTimes Set times for the clinic
* @property {string} setResourcesAndPeople Set resources and people for the clinic
* @property {object} settings Clinic settings
* @property {string} resources Clinic resources
* @property {integer} resource_ids Clinic resources ids
* @property {string} people Clinic people
* @property {integer} person_ids Clinic Person ids
* @property {string} services Clinic services
* @property {integer} services_ids Clinic service ids
* @property {string} uncovered The uncovered
* @property {string} className The class Name
* @property {string} start_time The clinic start thime
* @property {string} end_time The clinic end time
*///

angular.module('BB.Models').factory("AdminClinicModel", ($q, BBModel, BaseModel, ClinicModel) =>

  class Admin_Clinic extends ClinicModel {

    constructor(data) {
      super(data);
      if (!this.repeat_rule) { this.repeat_rule = {}; }
      if (!this.repeat_rule.rules) { this.repeat_rule.rules = {}; }
    }

    /***
    * @ngdoc method
    * @name calcRepeatRule
    * @methodOf BB.Models:AdminClinic
    * @description
    * Calculate the repeat rule
    *
    * @returns {array} Returns an array of repeat rules
    */
    calcRepeatRule() {
      let en;
      let vals = {};
      vals.name = this.name;
      vals.start_time = this.start_time.format("HH:mm");
      vals.end_time = this.end_time.format("HH:mm");
      vals.address_id = this.address_id;
      vals.resource_ids = [];
      for (var id in this.resources) {
        en = this.resources[id];
        if (en) { vals.resource_ids.push(id); }
      }
      vals.person_ids = [];
      for (id in this.people) {
        en = this.people[id];
        if (en) { vals.person_ids.push(id); }
      }
      vals.service_ids = [];
      for (id in this.services) {
        en = this.services[id];
        if (en) { vals.service_ids.push(id); }
      }

      this.repeat_rule.properties = vals;
      return this.repeat_rule;
    }

    /***
    * @ngdoc method
    * @name getPostData
    * @methodOf BB.Models:AdminClinic
    * @description
    * Get post data
    *
    * @returns {array} Returns an array with data
    */
    getPostData() {
      let en;
      let data = {};
      data.name = this.name;
      data.repeat_rule = this.repeat_rule;
      data.start_time = this.start_time;
      data.end_time = this.end_time;
      data.resource_ids = [];
      data.update_for_repeat = this.update_for_repeat;
      for (var id in this.resources) {
        en = this.resources[id];
        if (en) { data.resource_ids.push(id); }
      }
      data.person_ids = [];
      for (id in this.people) {
        en = this.people[id];
        if (en) { data.person_ids.push(id); }
      }
      data.service_ids = [];
      for (id in this.services) {
        en = this.services[id];
        if (en) { data.service_ids.push(id); }
      }
      if (this.address) { data.address_id = this.address.id; }
      if (this.settings) { data.settings = this.settings; }
      if (this.repeat_rule && this.repeat_rule.rules && this.repeat_rule.rules.frequency) {
        data.repeat_rule = this.calcRepeatRule();
      }
      return data;
    }

    /***
    * @ngdoc method
    * @name save
    * @methodOf BB.Models:AdminClinic
    * @description
    * Save person id, resource id and service id
    *
    * @returns {array} Returns an array with resources and peoples
    */
    save() {
      this.person_ids = _.compact(_.map(this.people, function(present, person_id) {
        if (present) { return person_id; }
      }));
      this.resource_ids = _.compact(_.map(this.resources, function(present, resource_id) {
        if (present) { return resource_id; }
      }));
      this.service_ids = _.compact(_.map(this.services, function(present, service_id) {
        if (present) { return service_id; }
      }));
      return this.$put('self', {}, this).then(clinic => {
        this.updateModel(clinic);
        this.setTimes();
        return this.setResourcesAndPeople();
      }
      );
    }

    $update(data) {
      if (!data) { data = this; }
      return this.$put('self', {}, data).then(res => {
        return this.constructor(res);
      }
      );
    }
  }
);

