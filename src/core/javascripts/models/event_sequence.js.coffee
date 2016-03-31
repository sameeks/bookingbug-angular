'use strict';

###**
* @ngdoc service
* @name BB.Models:EventSequence
*
* @description
* Representation of an EventSequence Object
*
* @property {number} total_entries Total entries in event sequence
* @property {array} event_chains Event chains
####

angular.module('BB.Models').factory "EventSequenceModel", ($q, BBModel, BaseModel, EventSequenceService) ->

  class EventSequence extends BaseModel

    ###**
    * @ngdoc method
    * @name name
    * @methodOf BB.Models:EventSequence
    * @description
    * Gets the event sequence name.
    *
    * @returns {string} Event sequence name
    ###
    name: () ->
      @_data.name

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:EventSequence
    * @description
    * Static function that loads an array of event sequences from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company, params) ->
      EventSequenceService.query(company, params)
