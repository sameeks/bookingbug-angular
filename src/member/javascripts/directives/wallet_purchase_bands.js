// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Directives").directive("bbWalletPurchaseBands", $rootScope => {

        return {
            scope: true,
            restrict: "AE",
            templateUrl: "wallet_purchase_bands.html",
            controller: "Wallet",
            require: '^?bbWallet',
            link(scope, attr, elem, ctrl) {

                scope.member = scope.$eval(attr.member);
                if ($rootScope.member) {
                    if (!scope.member) {
                        scope.member = $rootScope.member;
                    }
                }

                return $rootScope.connection_started.then(function () {
                    if (ctrl) {
                        let deregisterWatch;
                        return deregisterWatch = scope.$watch('wallet', function () {
                            if (scope.wallet) {
                                scope.getWalletPurchaseBandsForWallet(scope.wallet);
                                return deregisterWatch();
                            }
                        });
                    } else {
                        return scope.getWalletForMember(scope.member).then(() => scope.getWalletPurchaseBandsForWallet(scope.wallet));
                    }
                });
            }
        };
    }
);
