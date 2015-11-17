'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminEventChain
*
* @description
* Representation of an Event Chain Object
*
* @property {integer} total_entries The Total entries
* @property {array} events An array with events
####


angular.module('BB.Models').factory "Admin.EventChainModel", ($q, BBModel, BaseModel) ->

  class Admin_EventChain extends BaseModel

    constructor: (data) ->
      super(data)

