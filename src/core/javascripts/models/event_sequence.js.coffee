'use strict'


###**
* @ngdoc service
* @name BB.Models:EventSequence
*
* @description
* Representation of an EventSequence Object
*
* @property {integer} total_entries The total of entries in  event groupst
* @property {array} event_chains An array with items of the event 
####


angular.module('BB.Models').factory "EventSequenceModel", ($q, BBModel, BaseModel) ->

  class EventSequence extends BaseModel
    name: () ->
      @_data.name
