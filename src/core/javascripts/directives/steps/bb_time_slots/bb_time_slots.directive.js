// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbTimeSlots
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of time slots for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} booking_item The booking item
* @property {date} start_date The start date
* @property {date} end_date The end date
* @property {array} slots The slots
* @property {object} validator The validator service - see {@link BB.Services:Validator validator Service}
*
*///


angular.module('BB.Directives').directive('bbTimeSlots', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'TimeSlots',
    link(scope, element, attrs) {
      if (attrs.bbItem) {
        scope.booking_item = scope.$eval( attrs.bbItem );
      }
      if (attrs.bbShowAll) {
        scope.show_all = true;
      }
    }
  })
);
