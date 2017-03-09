angular.module('BB.Controllers').controller('Total',

    function ($scope, $rootScope, $q, $location, $window, QueryStringService, LoadingService, BBModel) {

        let loader = LoadingService.$loader($scope).notLoaded();

        $rootScope.connection_started.then(
            () => {
                $scope.bb.payment_status = null;

                let id = QueryStringService('purchase_id');

                if (id && !$scope.bb.total) {
                    BBModel.PurchaseTotal.$query({url_root: $scope.bb.api_url, purchase_id: id}).then(
                        function (total) {
                            $scope.total = total;
                            loader.setLoaded();

                            // emit checkout:success event if the amount paid matches the total price
                            if (total.paid === total.total_price) {
                                return $scope.$emit("checkout:success", total);
                            }
                        });
                } else {
                    $scope.total = $scope.bb.total;
                    loader.setLoaded();

                    // emit checkout:success event if the amount paid matches the total price
                    if ($scope.total.paid === $scope.total.total_price) {
                        $scope.$emit("checkout:success", $scope.total);
                    }
                }

                // Reset ready for another booking
                return $scope.reset();
            }

            , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));

        /***
         * @ngdoc method
         * @name print
         * @methodOf BB.Directives:bbTotal
         * @description
         * Open new window from partial url
         */
        return $scope.print = () => {
            $window.open($scope.bb.partial_url + 'print_purchase.html?id=' + $scope.total.long_id, '_blank',
                'width=700,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
            return true;
        };
    });
