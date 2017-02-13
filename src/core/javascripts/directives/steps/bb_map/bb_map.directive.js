// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbMap
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of maps for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash}  bbMap A hash of options
* @property {object} mapLoaded The map has been loaded
* @property {object} mapReady The maps has been ready
* @property {object} map_init The initialization the map
* @property {object} range_limit The range limit
* @property {boolean} showAllMarkers Display or not all markers
* @property {array} mapMarkers The map markers
* @property {array} shownMarkers Display the markers
* @property {integer} numberedPin The numbered pin
* @property {integer} defaultPin The default pin
* @proeprty {boolean} hide_not_live_stores Hide or not the live stores
* @property {object} address The address
* @property {object} error_msg The error message
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
*///


angular.module('BB.Directives').directive('bbMap', () =>
  ({
    restrict: 'A',
    replace: true,
    scope : true,
    controller : 'MapCtrl'
  })
);
