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

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} company_id The id of the company that use the event chain.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminEventChain
    * @description
    * Gets a filtered collection of events chain.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of events chain.
    ###
    @query: (company, company_id, page, per_page) ->
      AdminEventChainService.query
        company: company
        company_id: company_id
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminEventChain', ($injector) ->
  $injector.get('Admin.EventChainModel')