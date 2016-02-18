angular.module('BB.Services').factory "MemberService",
($q, $rootScope, halClient, BBModel) ->

  refresh: (member) ->
    deferred = $q.defer()
    member.$flush('self')
    member.$get('self').then (member) =>
      member = new BBModel.Member.Member(member)
      deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  current: () ->
    deferred = $q.defer()
    callback = ->
      deferred.resolve($rootScope.member)
    setTimeout callback, 200
    # member = () ->
      # deferred.resolve($rootScope.member)
    deferred.promise

  updateMember: (member, params) ->
    deferred = $q.defer()
    member.$put('self', {}, params).then (member) =>
      member = new BBModel.Member.Member(member)
      deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  sendWelcomeEmail: (member, params) ->
    deferred = $q.defer()
    member.$post('send_welcome_email', params).then (member) =>
      member = new BBModel.Member.Member(member)
      deferred.resolve(member)
    , (err) =>
      deferred.reject(err)
    deferred.promise
