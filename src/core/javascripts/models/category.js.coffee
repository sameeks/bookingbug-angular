'use strict';


###**
* @ngdoc service
* @name BB.Models:Category
*
* @description
* Representation of a Category Object
####


angular.module('BB.Models').factory "CategoryModel", ($q, BBModel, BaseModel) ->

  class Category extends BaseModel

