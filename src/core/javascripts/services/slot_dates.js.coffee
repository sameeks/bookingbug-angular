'use strict'

###
* @ngdoc service
* @name BB.Services.service:SlotDates
*
* @description
* checks for the first date with available spaces
###
angular.module('BB.Services').factory 'SlotDates', ($q, DayService) ->
    cached =
      firstSlotDate : null
      timesQueried  : 0

    getFirstDayWithSlots: (cItem, selected_day) ->
      deferred = $q.defer()

      if cached.firstSlotDate?
        deferred.resolve cached.firstSlotDate
        return deferred.promise

      endDate = selected_day.clone().add(3, 'month')

      params =
        cItem: cItem
        date: selected_day.format('YYYY-MM-DD')
        edate endDate.format('YYYY-MM-DD')
      DayService.query(params).then (days) ->
        cached.timesQueried++

        firstAvailableSlots = _.find days, (day) -> day.spaces > 0
        if firstAvailableSlots
          cached.firstSlotDate = firstAvailableSlots.date
          deferred.resolve cached.firstSlotDate
        else
          if cached.timesQueried <= 4
            @getFirstDayWithSlots(cItem, endDate).then (day)->
              deferred.resolve cached.firstSlotDate
            , (err)->
              deferred.reject err
          else
            deferred.reject new Error('ERROR.NO_SLOT_AVAILABLE')
      , (err) ->
        deferred.reject new Error('ERROR.COULDNT_GET_AVAILABLE_DATES')

      return deferred.promise

