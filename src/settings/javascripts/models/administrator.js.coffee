'use strict'


###**
* @ngdoc service
* @name BB.Models:AdminAdministrator
*
* @description
* Representation of an Administrator Object
####


angular.module('BB.Models').factory "Admin.AdministratorModel", ($q, BBModel, BaseModel) ->

  class Admin_Administrator extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name query
    * @param {Company} company The company model.
    * @param {integer=} page Specifies particular page of paginated response.
    * @param {integer=} per_page Number of items per page of paginated response.
    * @methodOf BB.Models:AdminAdministrator
    * @description
    * Gets a filtered collection of people.
    *
    * @returns {Promise} Returns a promise that resolves to the filtered collection of people.
    ###
    @query: (company, page, per_page) ->
      AdminPersonService.query
        company: company
        page: page
        per_page: per_page

angular.module('BB.Models').factory 'AdminAdministrator', ($injector) ->
  $injector.get('Admin.AdministratorModel')