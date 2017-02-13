// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbDayList
* @restrict AE
* @scope true
*
* @description
*
* Next 5 week calendar with time selection
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*ice}
*///


angular.module('BB.Directives').directive('bbDayList', () =>
  ({
    restrict: 'A',
    replace: true,
    scope : true,
    controller : 'DayList'
  })
);
