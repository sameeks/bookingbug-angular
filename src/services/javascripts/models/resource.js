// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:AdminResource
*
* @description
* Representation of an Resource Object
*
* @property {integer} total_entries The total entries
* @property {array} resources An array with resources elements
* @property {integer} id The resources id
* @property {string} name Name of resources
* @propertu {string} type Type of resources
* @property {boolean} deleted Verify if resources is deleted or not
* @property {boolean} disabled Verify if resources is disabled or not
*///

angular.module('BB.Models').factory("AdminResourceModel", ($q, AdminResourceService, BBModel, BaseModel, ResourceModel) =>

  class Admin_Resource extends ResourceModel {

    /***
    * @ngdoc method
    * @name isAvailable
    * @methodOf BB.Models:AdminResource
    * @param {date=} start The start date of the availability of the resource
    * @param {date=} end The end date of the availability of the resource
    * @description
    * Look up a schedule for a time range to see if this available
    *
    * @returns {string} Returns yes if availability of resource is valid
    */
    // look up a schedule for a time range to see if this available
    // currently just checks the date - but chould really check the time too
    isAvailable(start, end) {
      let str = start.format("YYYY-MM-DD") + "-" + end.format("YYYY-MM-DD");
      if (!this.availability) { this.availability = {}; }

      if (this.availability[str]) { return this.availability[str] === "Yes"; }
      this.availability[str] = "-";

      if (this.$has('schedule')) {
        this.$get('schedule', {start_date: start.format("YYYY-MM-DD"), end_date: end.format("YYYY-MM-DD")}).then(sched => {
          this.availability[str] = "No";
          if (sched && sched.dates && sched.dates[start.format("YYYY-MM-DD")] && (sched.dates[start.format("YYYY-MM-DD")] !== "None")) {
            return this.availability[str] = "Yes";
          }
        }
        );
      } else {
        this.availability[str] = "Yes";
      }

      return this.availability[str] === "Yes";
    }

    static $query(params) {
      return AdminResourceService.query(params);
    }

    static $block(company, resource, data) {
      return AdminResourceService.block(company, resource, data);
    }
  }
);

