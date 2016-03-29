'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminEventChain
*
* @description
* Representation of an Event Chain Object
*
* @property {integer} total_entries The total entries of the event chain
* @property {array} event_groups An array with event chain
####

angular.module('BB.Models').factory "Admin.EventChainModel", ($q, BBModel, BaseModel) ->

  class Admin_EventChain extends BaseModel

    constructor: (data) ->
      super(data)
