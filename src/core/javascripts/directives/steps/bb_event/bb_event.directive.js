/***
* @ngdoc directive
* @name BB.Directives:bbEvent
* @restrict AE
* @scope true
*
* @description
* Loads a list of event for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {integer} total_entries The total entries of the event
* @property {array} events The events array
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
*///


angular.module('BB.Directives').directive('bbEvent', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'Event'
  })
);
