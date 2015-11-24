'use strict';


###**
* @ngdoc service
* @name BB.Models:EventSequence
*
* @description
* Representation of an EventSequence Object
*
* @property {integer} total_entries The total of entries in  event sequences
* @property {array} event_chains An array with items of the event 
####


angular.module('BB.Models').factory "EventSequenceModel", ($q, BBModel, BaseModel, EventSequenceService) ->

  class EventSequence extends BaseModel
    name: () ->
      @_data.name

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:EventSequence
    * @description
    * Static function that loads an array of event sequence from a company object
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company, params) ->
      EventSequenceService.query(company, params)