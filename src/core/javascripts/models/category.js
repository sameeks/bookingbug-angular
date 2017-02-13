// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:Category
*
* @description
* Representation of a Category Object
*///


angular.module('BB.Models').factory("CategoryModel", ($q, BBModel, BaseModel,
  CategoryService) =>

  class Category extends BaseModel {

    static $query(company) {
      return CategoryService.query(company);
    }
  }
);

