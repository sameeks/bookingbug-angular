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


angular.module('BB.Models').factory "Admin.EventGroupModel", ($q, BBModel, BaseModel, AdminEventGroupService) ->

  class Admin_EventGroup extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminEventGroup
    * @description
    * Static function that loads an array of events group from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminEventGroupService.query(params)

angular.module('BB.Models').factory 'AdminEventGroup', ($injector) ->
  $injector.get ('Admin.EventGroupModeln')
