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

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} company_id Id of the company that use this event group.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminEventGroup
    * @description
    * Gets a filtered collection of events group.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of events group.
    ###
    @query: (company, company_id, page, per_page) ->
      AdminEventChainService.query
        company: company
        company_id: company_id
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminEventGroup', ($injector) ->
  $injector.get('Admin.EventGroupModel')

