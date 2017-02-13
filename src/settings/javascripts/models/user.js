// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("Admin.UserModel", ($q, BBModel, BaseModel) =>

  class Admin_User extends BaseModel {

    constructor(data) {
      super(data);
      this.companies = [];
      if (data) {
        if (this.$has('companies')) {
          this.$get('companies').then(comps => {
            return this.companies = comps;
          }
          );
        }
      }
    }
  }
);

