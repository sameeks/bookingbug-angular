/***
 * @ngdoc service
 * @name BB.Models:Items
 *
 * @description
 * Representation of an Items Object
 *///


angular.module('BB.Models').factory("ItemsModel", ($q, $filter, BBModel, BaseModel) =>

    class Items extends BaseModel {

        constructor(data) {
            super(data);
        }
    }
);
