/***
 * @ngdoc directive
 * @name BB.Directives:bbCheckout
 * @restrict AE
 * @scope true
 *
 * @description
 * Loads a list of checkouts for the currently in scope company
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 *
 * @param {hash}  bbCheckout   A hash of options
 * @property {string} loadingTotal The loading total
 * @property {string} skipThisStep The skip this step
 * @property {string} decideNextPage The decide next page
 * @property {boolean} checkoutSuccess The checkout success
 * @property {string} setLoaded The set loaded
 * @property {string} setLoadedAndShowError The set loaded and show error
 * @property {boolean} checkoutFailed The checkout failed
 *///


angular.module('BB.Directives').directive('bbCheckout', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'Checkout'
        };
    }
);
