'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbDeals
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of deals for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} deals The deals list
* @property {object} validator The validator service - see {@link BB.Services:Validator Validator Service}
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
####


angular.module('BB.Directives').directive 'bbDeals', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'DealList'
