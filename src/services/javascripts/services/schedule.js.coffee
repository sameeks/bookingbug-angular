'use strict'

angular.module('BBAdmin.Services').factory 'AdminScheduleService',  ($q,
  BBModel, ScheduleRules, BBAssets) ->

  query: (params) ->
    company = params.company
    defer = $q.defer()
    company.$get('schedules').then (collection) ->
      collection.$get('schedules').then (schedules) ->
        models = (new BBModel.Admin.Schedule(s) for s in schedules)
        defer.resolve(models)
      , (err) ->
        defer.reject(err)
    , (err) ->
      defer.reject(err)
    defer.promise


  delete: (schedule) ->
    deferred = $q.defer()
    schedule.$del('self').then  (schedule) =>
      schedule = new BBModel.Admin.Schedule(schedule)
      deferred.resolve(schedule)
    , (err) =>
      deferred.reject(err)

    deferred.promise

  update: (schedule) ->
    deferred = $q.defer()
    schedule.$put('self', {}, schedule.getPostData()).then (c) =>
      schedule = new BBModel.Admin.Schedule(c)
      deferred.resolve(schedule)
    , (err) =>
      deferred.reject(err)

  mapAssetsToScheduleEvents: (start, end, assets) ->
    assets_with_schedule = _.filter assets, (asset)->
      asset.$has('schedule')

    _.map assets_with_schedule, (asset) ->
      params =
        start_date: start.format('YYYY-MM-DD')
        end_date: end.format('YYYY-MM-DD')

      asset.$get('schedule', params).then (schedules) ->
        rules = new ScheduleRules(schedules.dates)
        events = rules.toEvents()
        _.each events, (e) ->
          e.resourceId = asset.id
          e.title = asset.name
          e.rendering = "background"
        events

  getAssetsScheduleEvents: (company, start, end, filtered = false, requested = []) ->
    if filtered
      $q.all(@mapAssetsToScheduleEvents(start, end, requested)).then (schedules) ->
        _.flatten(schedules)
    else
      localMethod = @mapAssetsToScheduleEvents
      BBAssets(company).then (assets)->
        $q.all(localMethod(start, end, assets)).then (schedules) ->
          _.flatten(schedules)

