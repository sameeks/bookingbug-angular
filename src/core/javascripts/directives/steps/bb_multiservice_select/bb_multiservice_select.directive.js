/***
* @ngdoc directive
* @name BB.Directives:bbMultiServiceSelect
* @restrict AE
* @scope true
*
* @description
*
* Loads a list of multi service selected for the currently in scope company
*
* <pre>
* restrict: 'AE'
* scope: true
* </pre>
*
* @param {hash}  bbMultiServiceSelect A hash of options
* @property {object} options The options of service
* @property {object} max_services The max services
* @property {boolean} ordered_categories Verify if categories are ordered or not
* @property {array} services The services
* @property {array} company The company
* @property {array} items An array of items service
* @property {object} alert The alert service - see {@link BB.Services:Alert Alert Service}
*///


angular.module('BB.Directives').directive('bbMultiServiceSelect', () =>
  ({
    restrict: 'AE',
    scope : true,
    controller : 'MultiServiceSelect'
  })
);
