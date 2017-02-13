/***
* @ngdoc service
* @name BB.Models:Clinic
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
* @property {string} start The clinic start
* @property {string} end_time The clinic end time
* @property {string} end The clinic end
* @property {string} title The title
*///


angular.module('BB.Models').factory("ClinicModel", ($q, BBModel, BaseModel) =>

  class Clinic extends BaseModel {

    constructor(data) {
      super(data);
      this.setTimes();
      this.setResourcesAndPeople();
      if (!this.settings) { this.settings = {}; }
    }


    /***
    * @ngdoc method
    * @name setResourcesAndPeople
    * @methodOf BB.Models:Clinic
    * @description
    * Set resources and people for clinic
    *
    * @returns {object} The returned resources and people
    */
    setResourcesAndPeople() {
      this.resources = _.reduce(this.resource_ids, function(h, id) {
        h[id] = true;
        return h;
      }
      , {});
      this.people = _.reduce(this.person_ids, function(h, id) {
        h[id] = true;
        return h;
      }
      , {});
      this.services = _.reduce(this.service_ids, function(h, id) {
        h[id] = true;
        return h;
      }
      , {});
      this.uncovered = !this.person_ids || (this.person_ids.length === 0);
      if (this.uncovered) {
        return this.className = "clinic_uncovered";
      } else {
        return this.className = "clinic_covered";
      }
    }


    /***
    * @ngdoc method
    * @name setTimes
    * @methodOf BB.Models:Clinic
    * @description
    * Set time for clinic
    *
    * @returns {object} The returned time
    */
    setTimes() {
      if (this.start_time) {
        this.start_time = moment(this.start_time);
        this.start = this.start_time;
      }
      if (this.end_time) {
        this.end_time = moment(this.end_time);
        this.end = this.end_time;
      }
      return this.title = this.name;
    }
  }
);

