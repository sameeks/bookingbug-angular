angular.module('BB.Controllers').controller('PurchaseTotal', function ($scope,
                                                                       $rootScope, $window, BBModel, $q) {

    angular.extend(this, new $window.PageController($scope, $q));

    /***
     * @ngdoc method
     * @name load
     * @methodOf BB.Directives:bbPurchaseTotal
     * @description
     * Load the total purchase by id
     *
     * @param {integer} total_id The total id of the total purchase
     */
    return $scope.load = total_id => {
        return $rootScope.connection_started.then(() => {
                $scope.loadingTotal = BBModel.PurchaseTotal.$query({company: $scope.bb.company, total_id});
                return $scope.loadingTotal.then(total => {
                        return $scope.total = total;
                    }
                );
            }
        );
    };
});
