// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
* @ngdoc directive
* @name BB.Directives:bbBasketSummary
* @restrict AE
* @scope true
*
* @description
* Loads a summary of the bookings and allows the user to  review and
* confirm the previously entered information
*///


angular.module('BB.Directives').directive('bbBasketSummary', () =>
  ({
    restrict: 'AE',
    replace: true,
    scope : true,
    controller : 'BasketSummary'
  })
);
