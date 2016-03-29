angular.module('BBAdmin.Services').factory 'AdminScheduleService',  ($q, BBModel, ScheduleRules) ->

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

  mapPeopleToScheduleEvents: (start, end, people) ->
    _.map people, (p) ->
      params =
        start_date: start.format('YYYY-MM-DD')
        end_date: end.format('YYYY-MM-DD')
      p.$get('schedule', params).then (schedules) ->
        rules = new ScheduleRules(schedules.dates)
        events = rules.toEvents()
        _.each events, (e) ->
          e.resourceId = p.id
          e.title = p.name
          e.rendering = "background"
        events

  getPeopleScheduleEvents: (company, start, end) ->
    company.getPeoplePromise().then (people) =>
      $q.all(@mapPeopleToScheduleEvents(start, end, people)).then (schedules) ->
        _.flatten(schedules)

