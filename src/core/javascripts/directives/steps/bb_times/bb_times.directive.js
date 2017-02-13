/***
* @ngdoc directive
* @name BB.Directives:bbTimes
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of times for the currently in scope company
*
* <pre>
* restrict: 'AE'
* replace: true
* scope: true
* </pre>
*
* @param {hash} bbTimes A hash of options
* @property {array} selected_day The selected day
* @property {date} selected_date The selected date
* @property {array} data_source The data source
* @property {array} item_link_source The item link source
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
*
*///


angular.module('BB.Directives').directive('bbTimes', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'TimeList'
  })
);
