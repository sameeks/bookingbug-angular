'use strict'

angular.module('BB.Models').factory "LoginModel", (
  $q, LoginService, BBModel, BaseModel) ->

  class Login extends BaseModel

    constructor: (data) ->
      super(data)

    @$companyLogin: (company, params, form) ->
      LoginService.companyLogin(company, params, form)

    @$login: (form, options) ->
      LoginService.login(form, options)

    @$FBLogin: (company, params) ->
      LoginService.FBLogin(company, params)

    @$companyQuery: (id) ->
      LoginService.companyQuery(id)

    @$memberQuery: (params) ->
      LoginService.memberQuery(params)

    @$ssoLogin: (options, data) ->
      LoginService.ssoLogin(options, data)

    @$isLoggedIn: () ->
      LoginService.isLoggedIn()

    @$setLogin: (member, persist) ->
      LoginService.setLogin(member, persist)

    @$member: () ->
      LoginService.member()

    @$checkLogin: () ->
      LoginService.checkLogin()

    @$logout: () ->
      LoginService.logout()

    @$FBLogout: (options) ->
      LoginService.FBLogout(options)

    @$sendPasswordReset: (company, params) ->
      LoginService.sendPasswordReset(company, params)

    @$updatePassword: (member, params) ->
      LoginService.updatePassword(member, params)

