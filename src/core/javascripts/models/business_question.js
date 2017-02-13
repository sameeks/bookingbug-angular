// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:BussinessQuestion
*
* @description
* Representation of an BussinessQuestion Object
*///


angular.module('BB.Models').factory("BusinessQuestionModel", ($q, $filter,
  BBModel, BaseModel) =>

  class BusinessQuestion extends BaseModel {

    constructor(data) {
      super(data);
    }
  }
);

