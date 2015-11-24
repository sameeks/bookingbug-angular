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
    * @param {Company} company The company model.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminEventChain
    * @description
    * Gets a filtered collection of event chain.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of event chain.
    ###
    @query: (company, page, per_page) ->
      AdminEventChainService.query
        company: company
        page: page
        per_page: per_page

angular.module('BB.Models').factory "AdminEventChain", ($injector) ->
  $injector.get('Admin.EventChainModel')