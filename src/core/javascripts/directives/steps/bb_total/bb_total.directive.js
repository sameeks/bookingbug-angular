// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbTotal
 * @restrict AE
 * @scope true
 *
 * @description
 *
 * Loads a list of totals for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash}  bbTotal A hash of options
 * @property {array} payment_status The payment status
 * @property {array} total The total
 *///


angular.module('BB.Directives').directive('bbTotal', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Total'
        };
    }
);
