'use strict'

###**
* @ngdoc service
* @name BB.Models:AdminAdministrator
*
* @description
* Representation of an Administrator Object
####

angular.module('BB.Models').factory "Admin.AdministratorModel", ($q, BBModel, BaseModel, AdminAdministratorService) ->

  class Admin_Administrator extends BaseModel

    constructor: (data) ->
      super(data)

    ###**
    * @ngdoc method
    * @name query
    * @methodOf BB.Models:AdminAdministrator
    * @description
    * Static function that loads an array of administrators from a company object
    *
    * @returns {Promise} A returned promise
    ###
    @$query: (params) ->
      AdminAdministratorService.query(params)

angular.module('BB.Models').factory 'AdminAdministrator', ($injector) ->
  $injector.get('Admin.AdministratorModel')
