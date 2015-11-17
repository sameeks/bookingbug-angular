'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminEventGroup
*
* @description
* Representation of an Event Group Object
*
* @property {integer} total_entries The Total entries
* @property {array} events An array with events
####


angular.module('BB.Models').factory "Admin.EventGroupModel", ($q, BBModel, BaseModel) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)

