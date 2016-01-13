'use strict';

angular.module('BB.Models').factory "PackageItemModel", ($q, BBModel, BaseModel) ->

  class PackageItem extends BaseModel

  #angular.extend(this, new PageControllerService($scope, $q))