'use strict';

###**
* @ngdoc service
* @name BB.Models:PackageItem
*
* @description
* Representation of a PackageItem Object
####

angular.module('BB.Models').factory "PackageItemModel", ($q, BBModel, BaseModel) ->

  class PackageItem extends BaseModel

