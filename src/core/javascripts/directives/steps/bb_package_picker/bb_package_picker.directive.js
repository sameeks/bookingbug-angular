// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbPackagePicker
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of package pickers for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {date} sel_date The sel date
* @property {date} selected_date The selected date
* @property {boolean} picked_time The picked time
* @property {array} timeSlots The time slots
* @property {boolean} data_valid The valid data
*///


angular.module('BB.Directives').directive('bbPackagePicker', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'PackagePicker'
  })
);
