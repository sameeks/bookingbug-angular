'use strict'

angular.module('BB.Services').factory "DayService", ($q, BBModel) ->

  query: (prms) ->

    deferred = $q.defer()

    if prms.cItem.days_link

      extra                 = {}
      extra.month           = prms.month
      extra.date            = prms.date
      extra.edate           = prms.edate
      extra.people_ids      = prms.people_ids if prms.people_ids
      extra.resource_ids    = prms.resource_ids if prms.resource_ids
      extra.person_group_id = prms.person_group_id if prms.person_group_id

      prms.cItem.days_link.$get('days', extra).then (found) =>

        afound = found.days
        days = []

        for i in afound

          if (i.type == prms.item)
            days.push(new BBModel.Day(i))

        deferred.resolve(days)

      , (err) =>
        deferred.reject(err)

    else

      deferred.reject("No Days Link found")

    deferred.promise
