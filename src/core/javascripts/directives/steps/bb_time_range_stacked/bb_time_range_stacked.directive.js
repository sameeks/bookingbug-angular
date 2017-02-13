// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
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
*///


angular.module('BB.Directives').directive('bbTimeRangeStacked', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'TimeRangeListStackedController'
  })
);
