angular.module('BB.Models').factory("AdminEventModel", ($q, BBModel, BaseModel) =>

  class Admin_Event extends BaseModel {

    constructor(data) {
      super(data);
    }
  }
);

