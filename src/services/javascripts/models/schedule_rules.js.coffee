'use strict'


###**
* @ngdoc service
* @name BB.Models:ScheduleRules
*
* @description
* Representation of an Schedule Rules Object
*
* @property {object} rules The schedule rules
####


angular.module('BB.Models').factory "ScheduleRules", () ->

  class ScheduleRules

    constructor: (rules = {}) ->
      @rules = rules

    ###**
    * @ngdoc method
    * @name addRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Add date range in according of the start and end parameters
    *
    * @returns {date} Returns the added date
    ###
    addRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'YYYY-MM-DD', @addRangeToDate)

    ###**
    * @ngdoc method
    * @name removeRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Remove date range in according of the start and end parameters
    *
    * @returns {date} Returns the removed date
    ###
    removeRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'YYYY-MM-DD', @removeRangeFromDate)

    ###**
    * @ngdoc method
    * @name addWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Add week day range in according of the start and end parameters
    *
    * @returns {date} Returns the week day
    ###
    addWeekdayRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'd', @addRangeToDate)

    ###**
    * @ngdoc method
    * @name removeWeekdayRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date of the range
    * @param {date=} end The end date of the range
    * @description
    * Remove week day range in according of the start and end parameters
    *
    * @returns {date} Returns removed week day
    ###
    removeWeekdayRange: (start, end) ->
      @applyFunctionToDateRange(start, end, 'd', @removeRangeFromDate)

    ###**
    * @ngdoc method
    * @name addRangeToDate
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} date The date
    * @param {array=} range The range of the date
    * @description
    * Add range to date in according of the date and range parameters
    *
    * @returns {date} Returns the added range of date
    ###
    addRangeToDate: (date, range) =>
      ranges = if @rules[date] then @rules[date] else []
      @rules[date] = @joinRanges(@insertRange(ranges, range))

    ###**
    * @ngdoc method
    * @name removeRangeFromDate
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} date The date
    * @param {array=} range The range of the date
    * @description
    * Remove range to date in according of the date and range parameters
    *
    * @returns {date} Returns the removed range of date
    ###
    removeRangeFromDate: (date, range) =>
      ranges = if @rules[date] then @rules[date] else []
      @rules[date] = @joinRanges(@subtractRange(ranges, range))
      delete @rules[date] if @rules[date] == ''

    ###**
    * @ngdoc method
    * @name applyFunctionToDateRange
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date
    * @param {date=} end The end date
    * @param {date=} format The format of the range date
    * @param {object} func The func of the date and range
    * @description
    * Apply date range in according of the start, end, format and func parameters
    *
    * @returns {array} Returns the rules
    ###
    applyFunctionToDateRange: (start, end, format, func) ->
      days = @diffInDays(start, end)
      if days == 0
        date = start.format(format)
        range = [start.format('HHmm'), end.format('HHmm')].join('-')
        func(date, range)
      else
        end_time = moment(start).endOf('day')
        @applyFunctionToDateRange(start, end_time, format, func)
        _.each([1..days], (i) =>
          date = moment(start).add(i, 'days')
          if i == days
            unless end.hour() == 0 && end.minute() == 0
              start_time = moment(end).startOf('day')
              @applyFunctionToDateRange(start_time, end, format, func)
          else
            start_time = moment(date).startOf('day')
            end_time = moment(date).endOf('day')
            @applyFunctionToDateRange(start_time, end_time, format, func)
        )
      @rules

    ###**
    * @ngdoc method
    * @name diffInDays
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} start The start date
    * @param {date=} end The end date
    * @description
    * Difference in days in according of the start and end parameters
    *
    * @returns {array} Returns the difference in days
    ###
    diffInDays: (start, end) ->
      moment.duration(end.diff(start)).days()

    ###**
    * @ngdoc method
    * @name insertRange
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @param {object} range The range
    * @description
    * Insert range in according of the ranges and range parameters
    *
    * @returns {array} Returns the ranges
    ###
    insertRange: (ranges, range) ->
      ranges.splice(_.sortedIndex(ranges, range), 0, range)
      ranges

    ###**
    * @ngdoc method
    * @name subtractRange
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @param {object} range The range
    * @description
    * Substract the range in according of the ranges and range parameters
    *
    * @returns {array} Returns the range decreasing
    ###
    subtractRange: (ranges, range) ->
      if _.indexOf(ranges, range, true) > -1
        _.without(ranges, range)
      else
        _.flatten(_.map(ranges, (r) ->
          if range.slice(0, 4) >= r.slice(0, 4) && range.slice(5, 9) <= r.slice(5, 9)
            if range.slice(0, 4) == r.slice(0, 4)
              [range.slice(5, 9), r.slice(5, 9)].join('-')
            else if range.slice(5, 9) == r.slice(5, 9)
              [r.slice(0, 4), range.slice(0, 4)].join('-')
            else
              [[r.slice(0, 4), range.slice(0, 4)].join('-'),
               [range.slice(5, 9), r.slice(5, 9)].join('-')]
          else
            r
        ))

    ###**
    * @ngdoc method
    * @name joinRanges
    * @methodOf BB.Models:ScheduleRules
    * @param {object} ranges The ranges
    * @description
    * Join ranges
    *
    * @returns {array} Returns the range
    ###
    joinRanges: (ranges) ->
      _.reduce(ranges, (m, range) ->
        if m == ''
          range
        else if range.slice(0, 4) <= m.slice(m.length - 4, m.length)
          if range.slice(5, 9) >= m.slice(m.length - 4, m.length)
            m.slice(0, m.length - 4) + range.slice(5, 9)
          else
            m
        else
          [m,range].join()
      , "").split(',')

    ###**
    * @ngdoc method
    * @name filterRulesByDates
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Filter rules by dates
    *
    * @returns {array} Returns the filtered rules by dates
    ###
    filterRulesByDates: () ->
      _.pick @rules, (value, key) ->
        key.match(/^\d{4}-\d{2}-\d{2}$/) && value != "None"

    ###**
    * @ngdoc method
    * @name filterRulesByWeekdays
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Filter rules by week day
    *
    * @returns {array} Returns the filtered rules by week day
    ###
    filterRulesByWeekdays: () ->
      _.pick @rules, (value, key) ->
        key.match(/^\d$/)

    ###**
    * @ngdoc method
    * @name formatTime
    * @methodOf BB.Models:ScheduleRules
    * @param {date=} time The time
    * @description
    * Format the time in according of the time parameter
    *
    * @returns {date} Returns the formated time
    ###
    formatTime: (time) ->
      [time[0..1],time[2..3]].join(':')

    ###**
    * @ngdoc method
    * @name toEvents
    * @methodOf BB.Models:ScheduleRules
    * @param {array} d The day of events
    * @description
    * Go to events day
    *
    * @returns {array} Returns fullcalendar compatible events
    ###
    toEvents: (d) ->
      if d && @rules[d] != "None"
        _.map(@rules[d], (range) =>
          start: [d, @formatTime(range.split('-')[0])].join('T')
          end: [d, @formatTime(range.split('-')[1])].join('T')
        )
      else
        _.reduce(@filterRulesByDates(), (memo, ranges, date) =>
          memo.concat(_.map(ranges, (range) =>
            start: [date, @formatTime(range.split('-')[0])].join('T')
            end: [date, @formatTime(range.split('-')[1])].join('T')
          ))
        ,[])

    ###**
    * @ngdoc method
    * @name toWeekdayEvents
    * @methodOf BB.Models:ScheduleRules
    * @description
    * Go to events week day
    *
    * @returns {array} Returns fullcalendar compatible events
    ###
    toWeekdayEvents: () ->
      _.reduce(@filterRulesByWeekdays(), (memo, ranges, day) =>
        date = moment().set('day', day).format('YYYY-MM-DD')
        memo.concat(_.map(ranges, (range) =>
          start: [date, @formatTime(range.split('-')[0])].join('T')
          end: [date, @formatTime(range.split('-')[1])].join('T')
        ))
      ,[])

