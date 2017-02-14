// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:BookableItem
 *
 * @description
 * Representation of an BookableItem Object
 *
 * @property {string} name Property name display "-Waiting-"
 * @property {string} ready The ready
 * @property {string} promise The promise
 * @property {string} item Bookable item
 *///


angular.module('BB.Models').factory("BookableItemModel", ($q, BBModel, BaseModel, ItemService) =>

    __initClass__(class BookableItem extends BaseModel {
        static initClass() {

            this.prototype.item = null;

            this.prototype.promise = null;
        }


        constructor(data) {
            super(...arguments);
            this.name = "-Waiting-";
            this.ready = $q.defer();
            this.promise = this._data.$get('item');
            this.promise.then(val => {
                    let m, n;
                    if (val.type === "person") {
                        this.item = new BBModel.Person(val);
                        if (this.item) {
                            for (n in this.item._data) {
                                m = this.item._data[n];
                                if (this.item._data.hasOwnProperty(n) && (typeof m !== 'function')) {
                                    this[n] = m;
                                }
                            }
                            return this.ready.resolve();
                        } else {
                            return this.ready.resolve();
                        }
                    } else if (val.type === "resource") {
                        this.item = new BBModel.Resource(val);
                        if (this.item) {
                            for (n in this.item._data) {
                                m = this.item._data[n];
                                if (this.item._data.hasOwnProperty(n) && (typeof m !== 'function')) {
                                    this[n] = m;
                                }
                            }
                            return this.ready.resolve();
                        } else {
                            return this.ready.resolve();
                        }
                    } else if (val.type === "service") {
                        this.item = new BBModel.Service(val);
                        if (this.item) {
                            for (n in this.item._data) {
                                m = this.item._data[n];
                                if (this.item._data.hasOwnProperty(n) && (typeof m !== 'function')) {
                                    this[n] = m;
                                }
                            }
                            return this.ready.resolve();
                        } else {
                            return this.ready.resolve();
                        }
                    }
                }
            );
        }

        static $query(params) {
            return ItemService.query(params);
        }
    })
);


function __initClass__(c) {
    c.initClass();
    return c;
}
