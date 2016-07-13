'use strict'


###**
* @ngdoc service
* @name BB.Models:Slot
*
* @description
* Representation of an Slot Object
*
* @property {integer} total_entries The The total entries of the slot
* @property {array} slots An array with slots
###


angular.module('BB.Models').factory "SlotModel", ($q, BBModel, BaseModel, SlotService) ->

  class Slot extends BaseModel

    constructor: (data) ->
      super(data)
      @datetime = moment(data.datetime)

    @$query: (company, params) ->
      SlotService.query(company, params)
