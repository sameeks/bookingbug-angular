'use strict'

angular.module('BB.Models').factory "Admin.CompanyModel", (CompanyModel,
  AdminCompanyService) ->

  class Admin_Company extends CompanyModel

    constructor: (data) ->
      super(data)

    @$query: (params) ->
      AdminCompanyService.query(params)

