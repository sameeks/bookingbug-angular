angular.module('BB.Services').factory "MemberService", ($q, halClient, $rootScope, BBModel) ->

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


  # TODO complete member create method
  # createMember: (company, client) ->
  #   deferred = $q.defer()
    
  #   if !company.$has('member')
  #     deferred.reject("Cannot create new members for this company")
  #   else
  #     MutexService.getLock().then (mutex) ->
  #       company.$post('member', {}, client.getPostData()).then (member) =>
  #         deferred.resolve(new BBModel.Member.Member(member))
  #         MutexService.unlock(mutex)
  #       , (err) =>
  #         deferred.reject(err)
  #         MutexService.unlock(mutex)

  #   deferred.promise