// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/***
 * @ngdoc directive
 * @name BB.Directives:bbWalletRemainder
 * @restrict A
 * @scope
 *   basketTotal: '='
 *   walletAmount: '='
 * @description
 *
 * Calculates wallet remainder
 *
 */

angular.module('BB.Directives').directive('bbWalletRemainder', () =>
    ({
        restrict: 'A',
        scope: {
            totalPrice: '=',
            walletAmount: '='
        },
        controllerAs: 'vm',
        bindToController: true,
        template: '<span translate="PUBLIC_BOOKING.BASKET.WALLET.REMAINDER" translate-values="{remainder: vm.amountRemaining}"></span>',
        controller() {
            return this.amountRemaining = this.walletAmount - this.totalPrice;
        }
    })
);
