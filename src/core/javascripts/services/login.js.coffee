
angular.module('BB.Services').factory "LoginService", ($q, halClient, $rootScope, BBModel, $sessionStorage) ->
  companyLogin: (company, params, form) ->
    deferred = $q.defer()
    company.$post('login', params, form).then (login) =>
      login.$get('member').then (member) =>
        @setLogin(member)
        deferred.resolve(member);
      , (err) =>
        deferred.reject(err)
    , (err) =>
      deferred.reject(err)
    deferred.promise
  

  login: (form, options) ->
    deferred = $q.defer()
    options['root'] ||= ""
    url = options['root'] + "/api/v1/login"
    halClient.$post(url, options, form).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('member').then (member) =>
        @setLogin(member)
        deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  FBLogin: (prms) ->
    deferred = $q.defer()
    company.$post('facebook_login', {}, params).then (login) =>
      login.$get('member').then (member) =>
        @setLogin(member)
        deferred.resolve(member);
      , (err) =>
        deferred.reject(err)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  
  companyQuery: (id) =>
    if id
      comp_promise = halClient.$get(location.protocol + '//' + location.host + '/api/v1/company/' + id)
      comp_promise.then (company) =>
        company = new BBModel.Company(company)

  memberQuery: (params) =>
    if params.member_id && params.company_id
      member_promise = halClient.$get(location.protocol + '//' + location.host + "/api/v1/#{params.company_id}/" + "members/" + params.member_id)
      member_promise.then (member) =>
        member = new BBModel.Member.Member(member)

  ssoLogin: (options, data) ->
    deferred = $q.defer()
    options['root'] ||= ""
    url = options['root'] + "/api/v1/login/sso/" + options['company_id']
    halClient.$post(url, {}, data).then (login) =>
      params = {auth_token: login.auth_token}
      login.$get('member').then (member) =>
        member = new BBModel.Member.Member(member)
        @setLogin(member)
        deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

      

  # check if we're logged in as a member - but not an admin
  isLoggedIn: ->
    @checkLogin()
    if $rootScope.member && (!$rootScope.user or $rootScope.user is undefined)
      true
    else
      false

  setLogin: (member) ->
    auth_token = member.getOption('auth_token')
    member = new BBModel.Member.Member(member)
    $sessionStorage.setItem("login", member.$toStore())
    $sessionStorage.setItem("auth_token", auth_token)
    $rootScope.member = member
    member

  member: () ->
    @checkLogin()
    $rootScope.member

  checkLogin: () ->
    return if $rootScope.member

    member = $sessionStorage.getItem("login")
    if member
      $rootScope.member = halClient.createResource(member)

  logout: (options) ->

    $rootScope.member = null
    deferred = $q.defer()

    options ||= {}
    options['root'] ||= ""
    url = options['root'] + "/api/v1/logout"

    $sessionStorage.removeItem("login")
    $sessionStorage.removeItem('auth_token')
    $sessionStorage.clear()
    
    halClient.$del(url, options, {}).then (logout) =>
      $sessionStorage.removeItem("login")
      $sessionStorage.removeItem('auth_token')
      $sessionStorage.clear()
      deferred.resolve(true)
    , (err) =>
      deferred.reject(err)
    deferred.promise


  sendPasswordReset: (company, params) ->
    deferred = $q.defer()
    company.$post('email_password_reset', {}, params).then () =>
      deferred.resolve(true)
    , (err) =>
      deferred.reject(err)
    deferred.promise
  

  updatePassword: (member, params) ->
    params.auth_token = member.getOption('auth_token')
    if member && params['new_password'] && params['confirm_new_password']
      deferred = $q.defer()
      member.$post('update_password', {}, params).then (login) =>
        login.$get('member').then (member) =>
          @setLogin(member)
          deferred.resolve(member)
        , (err) =>
          deferred.reject(err)
      , (err) =>
        deferred.reject(err)
      deferred.promise

