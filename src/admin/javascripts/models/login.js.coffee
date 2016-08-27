'use strict'

angular.module('BB.Models').factory "AdminLoginModel", (
  $q, AdminLoginService, BBModel, BaseModel) ->

  class Admin_Login extends BaseModel

    constructor: (data) ->
      super(data)

    @$login: (form, options) ->
      AdminLoginService.login(form, options)

    @$ssoLogin: (options, data) ->
      AdminLoginService.ssoLogin(options, data)

    @$isLoggedIn: () ->
      AdminLoginService.isLoggedIn()

    @$setLogin: (user) ->
      AdminLoginService.setLogin(user)

    @$user: () ->
      AdminLoginService.user()

    @$checkLogin: (params) ->
      AdminLoginService.checkLogin(params)

    @$logout: () ->
      AdminLoginService.logout()

    @$getLogin: (options) ->
      AdminLoginService.getLogin(options)

    @$companyLogin: (company, params) ->
      AdminLoginService.companyLogin(company, params)

    @$memberQuery: (params) ->
      AdminLoginService.memberQuery(params)

    @$setCompany: (company_id) ->
      AdminLoginService.setCompany(company_id)

