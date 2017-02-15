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

angular.module('BB.Directives').directive('bbWalletRemainder', () => {
        return {
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
        };
    }
);
