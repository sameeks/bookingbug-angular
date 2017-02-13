// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("AdminEventChainModel", ($q, BBModel,
  BaseModel, EventChainService) =>

  class Admin_EventChain extends BaseModel {

    constructor(data) {
      super(data);
    }

    static $query(params) {
      return EventChainService.query(params);
    }
  }
);

