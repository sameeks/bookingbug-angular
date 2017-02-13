'use strict'

angular.module('BB.Models').factory "Admin.AdministratorModel", ($q,
  AdminAdministratorService, BBModel, BaseModel) ->

  class Admin_Administrator extends BaseModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      AdminAdministratorService.query(params)
