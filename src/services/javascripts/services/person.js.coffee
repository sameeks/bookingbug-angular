'use strict'

angular.module('BBAdminServices').factory 'AdminPersonService',  ($q, $window,
    $rootScope, halClient, SlotCollections, BookingCollections, BBModel,
    LoginService, $log) ->

  query: (params) ->
    company = params.company
    defer = $q.defer()
    if company.$has('people')
      company.$get('people', params).then (collection) ->
        if collection.$has('people')
          collection.$get('people').then (people) ->
            models = (new BBModel.Admin.Person(p) for p in people)
            defer.resolve(models)
          , (err) ->
            defer.reject(err)
        else
          obj = new BBModel.Admin.Person(collection)
          defer.resolve(obj)
      , (err) ->
        defer.reject(err)
    else
      $log.warn('company has no people link')
      defer.reject('company has no people link')
    defer.promise

  block: (company, person, data) ->
    deferred = $q.defer()
    person.$put('block', {}, data).then  (response) =>
      if response.$href('self').indexOf('bookings') > -1
        booking = new BBModel.Admin.Booking(response)
        BookingCollections.checkItems(booking)
        deferred.resolve(booking)
      else
        slot = new BBModel.Admin.Slot(response)
        SlotCollections.checkItems(slot)
        deferred.resolve(slot)
    , (err) =>
      deferred.reject(err)
    deferred.promise

  signup: (user, data) ->
    defer = $q.defer()
    user.$get('company').then (company) ->
      params = {}
      company.$post('people', params, data).then (person) ->
        if person.$has('administrator')
          person.$get('administrator').then (user) ->
            LoginService.setLogin(user)
            defer.resolve(person)
        else
          defer.resolve(person)
      , (err) ->
        defer.reject(err)
      defer.promise
