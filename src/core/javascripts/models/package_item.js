// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc service
* @name BB.Models:PackageItem
*
* @description
* Representation of a PackageItem Object
*///

angular.module('BB.Models').factory("PackageItemModel", ($q,
  PackageItemService, BBModel, BaseModel) =>

  class PackageItem extends BaseModel {

    static $query(company) {
      return PackageItemService.query(company);
    }

    static $getPackageServices(package_item) {
      return PackageItemService.getPackageServices(package_item);
    }
  }
);

