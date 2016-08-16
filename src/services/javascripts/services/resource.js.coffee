'use strict'

angular.module('BBAdmin.Services').factory 'AdminResourceService', ($q,
  UriTemplate, halClient, SlotCollections, BBModel, BookingCollections) ->

  query: (params) ->
    company = params.company
    defer = $q.defer()
    company.$get('resources').then (collection) ->
      collection.$get('resources').then (resources) ->
        models = (new BBModel.Admin.Resource(r) for r in resources)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise

  block: (company, resource, data) ->
    deferred = $q.defer()
    resource.$put('block', {}, data).then  (response) =>
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

