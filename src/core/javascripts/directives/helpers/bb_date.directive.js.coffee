'use strict'


angular.module('BB.Directives').directive 'bbDate', () ->
  restrict: 'AE'
  scope: true
  link : (scope, element, attrs) ->

    track_service = attrs.bbTrackService?

    # set the date, first test if bbDate has been set, otherwise use the current item's
    # date. If neither are set, set the date as today
    if attrs.bbDate
     date = moment( scope.$eval( attrs.bbDate ) )
    else if scope.bb && scope.bb.current_item && scope.bb.current_item.date
      date = scope.bb.current_item.date.date
    else
      date = moment()

    # if we've been instructed to track the service, set the min/max date
     if track_service && scope.bb.current_item && scope.bb.current_item.service
      scope.min_date = scope.bb.current_item.service.min_advance_datetime
      scope.max_date = scope.bb.current_item.service.max_advance_datetime

    # broadcast a dateChanged event to ensure listeners are updated
    scope.$broadcast('dateChanged', moment(date))

    # bb_date
    scope.bb_date = {

      date: date
      js_date: date.toDate()

      addDays: (type, amount) ->
        @date = moment(@date).add(amount, type)
        @js_date = @date.toDate()
        scope.$broadcast('dateChanged', moment(@date))

      subtractDays: (type, amount) ->
        @addDays(type, -amount)

      setDate: (date) ->
        @date    = date
        @js_date = date.toDate()
        scope.$broadcast('dateChanged', moment(@date))
    }

    # watch the current_item for updates
    scope.$on "currentItemUpdate", (event) ->

      # set the min/max date if a service has been set
      if scope.bb.current_item.service && track_service
        scope.min_date = scope.bb.current_item.service.min_advance_datetime
        scope.max_date = scope.bb.current_item.service.max_advance_datetime

        # if the bb_date is before/after the min/max date, move it to the min/max date
        scope.bb_date.setDate(scope.min_date.clone()) if scope.bb_date.date.isBefore(scope.min_date, 'day')
        scope.bb_date.setDate(scope.max_date.clone()) if scope.bb_date.date.isAfter(scope.max_date, 'day')

    # if the js_date has changed, update the moment date representation
    # and broadcast an update
    scope.$watch 'bb_date.js_date', (newval, oldval) ->
      ndate = moment(newval)
      if !scope.bb_date.date.isSame(ndate)
        scope.bb_date.date = ndate
        scope.$broadcast('dateChanged', moment(ndate)) if moment(ndate).isValid()
