// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbPurchaseTotal
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of purchase total for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @property {array} total The total purchase
 *///


angular.module('BB.Directives').directive('bbPurchaseTotal', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'PurchaseTotal'
        };
    }
);
