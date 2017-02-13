// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbGetAvailability
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of availability for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} earliest_day The availability of earliest day
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
*///


angular.module('BB.Directives').directive('bbGetAvailability', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'GetAvailability',
    link(scope, element, attrs) {
      if (attrs.bbGetAvailability) {
        scope.loadAvailability(scope.$eval( attrs.bbGetAvailability ) );
      }
    }
  })
);
