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

angular.module('BB.Models').factory "Admin.EventChainModel", ($q, BBModel, BaseModel, AdminEventChainService) ->

  class Admin_EventChain extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminEventChain
    * @description
    * Static function that loads an array of events chain from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminEventChainService.query (params)

angular.module('BB.Models').factory "AdminEventChain", ($injector) ->
  $injector.get('Admin.EventChainModel')
