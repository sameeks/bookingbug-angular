'use strict'

angular.module('BBAdmin.Services').factory 'AdminCompanyService', (
  $q, $rootScope, $sessionStorage, BBModel) ->

  query: (params) ->
    defer = $q.defer()
    $rootScope.bb ||= {}

    $rootScope.bb.api_url ||= $sessionStorage.getItem("host")
    $rootScope.bb.api_url ||= params.apiUrl
    $rootScope.bb.api_url ||= ""

    BBModel.Admin.Login.$checkLogin(params).then () ->
      if $rootScope.user && $rootScope.user.company_id
        $rootScope.bb ||= {}
        $rootScope.bb.company_id = $rootScope.user.company_id
        $rootScope.user.$get('company').then (company) ->
          defer.resolve(new BBModel.Company(company))
        , (err) ->
          defer.reject(err)
      else
        login_form =
          email: params.adminEmail
          password: params.adminPassword
        options =
          company_id: params.companyId
        BBModel.Admin.Login.$login(login_form, options).then (user) ->
          user.$get('company').then (company) ->
            defer.resolve(new BBModel.Company(company))
          , (err) ->
            defer.reject(err)
        , (err) ->
          defer.reject(err)
    defer.promise

