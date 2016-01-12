'use strict';

angular.module('BB.Models').factory "DealModel", ($q, BBModel, BaseModel, DealService) ->

  class Deal extends BaseModel

    @$query: (company) ->
      DealService.query(company)