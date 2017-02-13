// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Models').factory("DealModel", ($q, BBModel, BaseModel, DealService) =>

  class Deal extends BaseModel {

    static $query(company) {
      return DealService.query(company);
    }
  }
);

