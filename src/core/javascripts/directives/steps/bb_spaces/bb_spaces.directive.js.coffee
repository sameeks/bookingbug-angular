'use strict'


###**
* @ngdoc directive
* @name BB.Directives:bbSpaces
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of spaces for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {array} items An array of all services
* @property {space} space The currectly selected space
###


angular.module('BB.Directives').directive 'bbSpaces', () ->
  restrict: 'AE'
  replace: true
  scope : true
  controller : 'SpaceList'
