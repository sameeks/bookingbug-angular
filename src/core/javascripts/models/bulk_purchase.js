// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:BulkPurchase
*
* @description
* Representation of a BulkPurchase Object
*///

angular.module('BB.Models').factory("BulkPurchaseModel", ($q, BBModel,
  BaseModel, BulkPurchaseService) =>

  class BulkPurchase extends BaseModel {

    static $query(company) {
      return BulkPurchaseService.query(company);
    }
  }
);

