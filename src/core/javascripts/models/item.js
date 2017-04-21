/***
 * @ngdoc service
 * @name BB.Models:Items
 *
 * @description
 * Representation of an Items Object
 *///


angular.module('BB.Models').factory("ItemModel", ($q, $filter, BBModel, BaseModel) =>

    class Item extends BaseModel {

        constructor(data) {
            super(data);
        }
    }
);
