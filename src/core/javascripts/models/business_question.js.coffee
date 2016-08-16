'use strict'


###**
* @ngdoc service
* @name BB.Models:BussinessQuestion
*
* @description
* Representation of an BussinessQuestion Object
####


angular.module('BB.Models').factory "BusinessQuestionModel", ($q, $filter,
  BBModel, BaseModel) ->

  class BusinessQuestion extends BaseModel

    constructor: (data) ->
      super(data)

