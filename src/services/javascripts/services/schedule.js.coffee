'use strict'

angular.module('BBAdmin.Services').factory 'AdminScheduleService',  ($q,
  BBModel, ScheduleRules, BBAssets, GeneralOptions, CompanyStoreService) ->

  schedule_cache = {}

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


  cacheDates = (asset, dates) ->
    schedule_cache[asset.self] ||= {}
    for k,v of dates
      schedule_cache[asset.self][k] = v

  getCacheDates = (asset, start, end) ->

    return false if !schedule_cache[asset.self]
    st = moment(start)
    en = moment(end)
    curr = moment(start)
    dates = []

    asset_cache = schedule_cache[asset.self]
    while (curr.unix() < end.unix())
      test = curr.format('YYYY-MM-DD')
      return false if !asset_cache[test]
      dates[test] = asset_cache[test]
      curr = curr.add(1, 'day')

    return dates

  # return a promise to resovle any existing schedule cahcing stuff
  loadScheduleCaches = (assets) ->
    proms = []
    for asset in assets
      if asset.$has('immediate_schedule')
        do (asset) =>
          prom = asset.$get('immediate_schedule')
          proms.push(prom)
          prom.then (schedules) ->
            cacheDates(asset, schedules.dates)

    fin = $q.defer()
    if proms.length > 0
      $q.all(proms).then () ->
        fin.resolve()
    else
      fin.resolve()
    fin.promise


  mapAssetsToScheduleEvents: (start, end, assets) ->
    assets_with_schedule = _.filter assets, (asset)->
      asset.$has('schedule')

    _.map assets_with_schedule, (asset) ->

      mapEvents = (e) ->
        e.resourceId = parseInt(asset.id) + "_" + asset.type[0]
        e.title = asset.name
        e.rendering = "background"
        # Set company timezone to start, end dates.
        e.start = moment.tz(e.start, CompanyStoreService.time_zone)
        e.end = moment.tz(e.end, CompanyStoreService.time_zone)

        if GeneralOptions.custom_time_zone
          # Convert start, end to custom timezone
          e.start = moment.tz(e.start, GeneralOptions.display_time_zone)
          e.end = moment.tz(e.end, GeneralOptions.display_time_zone)
        return e

      found = getCacheDates(asset, start, end)
      if found
        rules = new ScheduleRules(found)
        events = rules.toEvents()
        _.each events, mapEvents
        prom = $q.defer()
        prom.resolve(events)
        prom.promise
      else
        params =
          start_date: start.format('YYYY-MM-DD')
          end_date: end.format('YYYY-MM-DD')

        asset.$get('schedule', params).then (schedules) ->
         # cacheDates(asset, schedules.dates)
          rules = new ScheduleRules(schedules.dates)
          events = rules.toEvents()
          _.each events, mapEvents
          events

  getAssetsScheduleEvents: (company, start, end, filtered = false, requested = []) ->
    if filtered
      loadScheduleCaches(requested).then () =>
        $q.all(@mapAssetsToScheduleEvents(start, end, requested)).then (schedules) ->
          _.flatten(schedules)
    else
      localMethod = @mapAssetsToScheduleEvents
      BBAssets.getAssets(company).then (assets)->
        loadScheduleCaches(assets).then () ->
          $q.all(localMethod(start, end, assets)).then (schedules) ->
            _.flatten(schedules)
