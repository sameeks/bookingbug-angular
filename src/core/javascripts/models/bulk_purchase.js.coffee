'use strict';

angular.module('BB.Models').factory "BulkPurchaseModel", ($q, BBModel, BaseModel) ->

  class BulkPurchase extends BaseModel

  #angular.extend(this, new PageControllerService($scope, $q))