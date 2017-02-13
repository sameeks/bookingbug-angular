// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("AdminEventGroupModel", ($q, BBModel,
  BaseModel, EventGroupService) =>

  class Admin_EventGroup extends BaseModel {

    constructor(data) {
      super(data);
    }

    static $query(params) {
      return EventGroupService.query(params);
    }
  }
);

