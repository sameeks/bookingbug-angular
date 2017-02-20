/***
 * @ngdoc service
 * @name BB.Models:EventGroup
 *
 * @description
 * Representation of an EventGroup Object
 *
 * @property {integer} total_entries The total of entries in  event groupst
 * @property {array} event_chains An array with items of the event
 *///


angular.module('BB.Models').factory("EventGroupModel", ($q, BBModel, BaseModel) =>

    class EventGroup extends BaseModel {

        name() {
            return this._data.name;
        }

        colour() {
            return this._data.colour;
        }
    }
);

