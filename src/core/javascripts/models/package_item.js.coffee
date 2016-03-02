'use strict';

###**
* @ngdoc service
* @name BB.Models:PackageItem
*
* @description
* Representation of a PackageItem Object
####

angular.module('BB.Models').factory "PackageItemModel",
($q, PackageItemService, BBModel, BaseModel) ->

  class PackageItem extends BaseModel

    @$query: (company) ->
      PackageItemService.query(company)

    @$getPackageServices: (package_item) ->
      PackageItemService.getPackageServices(package_item)

