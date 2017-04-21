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


angular.module('BB.Directives').directive('bbBasketSummary', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'BasketSummary'
        };
    }
);
