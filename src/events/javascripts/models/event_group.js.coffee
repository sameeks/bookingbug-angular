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
    * @param {Company} company The company model.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminEventGroup
    * @description
    * Gets a filtered collection of event group.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of event group.
    ###
    @query: (company, page, per_page) ->
      AdminEventGroupService.query
        company: company
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminEventGroup', ($injector) ->
  $injector.get ('Admin.EventGroupModeln')
