'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbEvents
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of events for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbEvents A hash of options
* @property {integer} total_entries The event total entries
* @property {array} events The events array
* @property {boolean} hide_fully_booked_events Hide fully booked events (i.e. events with only waitlist spaces left). Default is false.
####
angular.module('BB.Directives').directive 'bbEvents', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'EventList'

  link : (scope, element, attrs) ->

    scope.summary = attrs.summary?
    scope.events_options = scope.$eval(attrs.bbEvents) or {}

    # set the mode
    # 0 = Event summary (gets year summary and loads events a day at a time)
    # 1 = Next 100 events (gets next 100 events)
    # 2 = Next 100 events and event summary (gets event summary, loads next 100 events, and gets more events if requested)
    scope.mode = if scope.events_options and scope.events_options.mode then scope.events_options.mode else 0
    scope.mode = 0 if scope.summary

    # set the total number of events loaded?
    scope.per_page = scope.events_options.per_page if scope.events_options and scope.events_options.per_page

    return
