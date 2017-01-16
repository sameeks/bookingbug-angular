'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbTimeRangeStacked
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of time range stacked for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbTimeRangeStacked A hash of options
* @property {date} start_date The start date of time range list
* @property {date} end_date The end date of time range list
* @property {integer} available_times The available times of range list
* @property {object} day_of_week The day of week
* @property {object} selected_day The selected day from the multi time range list
* @property {object} original_start_date The original start date of range list
* @property {object} start_at_week_start The start at week start of range list
* @property {object} selected_slot The selected slot from multi time range list
* @property {object} selected_date The selected date from multi time range list
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbTimeRangeStacked', ($q, $templateCache, $compile) ->
  restrict: 'AE'
  replace: true
  scope : true
  transclude: true
  controller : 'TimeRangeListStackedController',
  link: (scope, element, attrs, controller, transclude) ->
    # focus on continue button after slot selected - for screen readers 
    scope.$on 'time:selected', ->
      btn = angular.element('#btn-continue')
      btn[0].disabled = false
      btn[0].focus()

    # date helpers
    scope.today = moment().toDate()
    scope.tomorrow = moment().add(1, 'days').toDate()

    scope.options = scope.$eval(attrs.bbTimeRangeRangeStacked) or {}

    transclude scope, (clone) =>

      # if there's content compile that or grab the week_calendar template
      has_content = clone.length > 1 || (clone.length is 1 and (!clone[0].wholeText or /\S/.test(clone[0].wholeText)))

      if has_content
        element.html(clone).show()
      else
        $q.when($templateCache.get('_week_calendar.html')).then (template) ->
          element.html(template).show()
          $compile(element.contents())(scope)