angular.module('BB.Models').factory("DealModel", ($q, BBModel, BaseModel, DealService) =>

  class Deal extends BaseModel {

    static $query(company) {
      return DealService.query(company);
    }
  }
);

