'use strict';

###**
* @ngdoc service
* @name BB.Models:EventGroup
*
* @description
* Representation of an EventGroup Object
*
* @property {number} total_entries The total of entries in  event groups
* @property {array} event_chains An array with items of the event
####

angular.module('BB.Models').factory "EventGroupModel", ($q, BBModel, BaseModel, EventGroupService) ->

  class EventGroup extends BaseModel

    ###**
    * @ngdoc method
    * @name name
    * @methodOf BB.Models:EventGroup
    * @description
    * Gets the event group name
    *
    * @returns {string} Event grup name
    ###
    name: () ->
      @_data.name

    ###**
    * @ngdoc method
    * @name colour
    * @methodOf BB.Models:EventGroup
    * @description
    * Gets the event group colour.
    *
    * @returns {string} Event grup colour
    ###
    colour: () ->
      @_data.colour

    ###**
    * @ngdoc method
    * @name $query
    * @methodOf BB.Models:EventGroup
    * @description
    * Static function that loads an array of event groups from a company object.
    *
    * @returns {promise} A returned promise
    ###
    @$query: (company, params) ->
      EventGroupService.query(company,params)
