'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminEvent
*
* @description
* This is the event object returned by the API
*
* @property {integer} total_entries The total entries
* @property {array} events An array with events
####

angular.module('BB.Models').factory "Admin.EventModel", ($q, BBModel, BaseModel) ->

  class Admin_Event extends BaseModel

    constructor: (data) ->
      super(data)
