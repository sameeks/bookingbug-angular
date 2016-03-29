'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminEventGroup
*
* @description
* Representation of an Event Group Object
*
* @property {integer} total_entries The total entries of the event group
* @property {array} event_groups An array with event groups
####

angular.module('BB.Models').factory "Admin.EventGroupModel", ($q, BBModel, BaseModel) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)
