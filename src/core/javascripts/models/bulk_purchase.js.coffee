'use strict'

###**
* @ngdoc service
* @name BB.Models:BulkPurchase
*
* @description
* Representation of a BulkPurchase Object
####

angular.module('BB.Models').factory "BulkPurchaseModel", ($q, BBModel,
  BaseModel, BulkPurchaseService) ->

  class BulkPurchase extends BaseModel

    @$query: (company) ->
      BulkPurchaseService.query(company)

