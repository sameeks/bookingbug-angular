// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("Admin.AdministratorModel", ($q,
  AdminAdministratorService, BBModel, BaseModel) =>

  class Admin_Administrator extends BaseModel {

    constructor(data) {
      super(data);
    }

    static $query(params) {
      return AdminAdministratorService.query(params);
    }
  }
);
