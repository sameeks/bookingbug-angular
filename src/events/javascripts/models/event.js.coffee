'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminEvent
*
* @description
* Representation of an Event Object
*
* @property {integer} total_entries The Total entries
* @property {array} events An array with events
####


angular.module('BB.Models').factory "Admin.EventModel", ($q, BBModel, BaseModel) ->

  class Admin_Event extends BaseModel

    constructor: (data) ->
      super(data)

