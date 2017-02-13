// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Slot
*
* @description
* Representation of an Slot Object
*
* @property {integer} total_entries The The total entries of the slot
* @property {array} slots An array with slots
*/


angular.module('BB.Models').factory("SlotModel", ($q, BBModel, BaseModel, SlotService) =>

  class Slot extends BaseModel {

    constructor(data) {
      super(data);
      this.datetime = moment(data.datetime);
    }

    static $query(company, params) {
      return SlotService.query(company, params);
    }
  }
);

