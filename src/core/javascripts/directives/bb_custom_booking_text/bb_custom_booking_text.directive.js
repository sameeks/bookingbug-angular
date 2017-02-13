// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbCustomBookingText
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of custom booking text for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @property {string} messages The messages text
* @property {string} setLoaded Loading set of custom text
* @property {object} setLoadedAndShowError Set loaded and show error
*///


angular.module('BB.Directives').directive('bbCustomBookingText', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'CustomBookingText'
  })
);


