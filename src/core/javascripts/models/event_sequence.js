// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc service
 * @name BB.Models:EventSequence
 *
 * @description
 * Representation of an EventSequence Object
 *
 * @property {integer} total_entries The total of entries in  event groupst
 * @property {array} event_chains An array with items of the event
 *///


angular.module('BB.Models').factory("EventSequenceModel", ($q, BBModel, BaseModel) =>

    class EventSequence extends BaseModel {
        name() {
            return this._data.name;
        }
    }
);

