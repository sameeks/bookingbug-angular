'use strict';

###**
* @ngdoc service
* @name BB.Models:Slot
*
* @description
* Representation of an Slot Object
*
* @property {number} total_entries Slot total entrie
* @property {array} slots An array with slots
###

angular.module('BB.Models').factory "SlotModel", ($q, BBModel, BaseModel, SlotService) ->

  class Slot extends BaseModel

   constructor: (data) ->
      super(data)
      @datetime = moment(data.datetime)

   ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:Slot
    * @description
    * Static function that loads an array of slot from a company object.
    *
    * @returns {promise} A returned promise
    ###
   @$query: (company, params) ->
   	SlotService.query(company, params)
