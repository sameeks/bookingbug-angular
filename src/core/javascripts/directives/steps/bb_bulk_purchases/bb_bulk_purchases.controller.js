// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Controllers').controller('BulkPurchase',
    function ($scope, $rootScope, BBModel) {

        $rootScope.connection_started.then(function () {
            if ($scope.bb.company) {
                return $scope.init($scope.bb.company);
            }
        });

        $scope.init = function (company) {
            if (!$scope.booking_item) {
                $scope.booking_item = $scope.bb.current_item;
            }
            return BBModel.BulkPurchase.$query(company).then(bulk_purchases => $scope.bulk_purchases = bulk_purchases);
        };


        /***
         * @ngdoc method
         * @name selectItem
         * @methodOf BB.Directives:bbBulkPurchases
         * @description
         * Select a bulk purchase into the current booking journey and route on to the next page dpending on the current page control
         *
         * @param {object} package Bulk_purchase or BookableItem to select
         * @param {string=} route A specific route to load
         */
        $scope.selectItem = function (item, route) {
            if ($scope.$parent.$has_page_control) {
                $scope.bulk_purchase = item;
                return false;
            } else {
                $scope.booking_item.setBulkPurchase(item);
                $scope.decideNextPage(route);
                return true;
            }
        };


        /***
         * @ngdoc method
         * @name setReady
         * @methodOf BB.Directives:bbBulkPurchases
         * @description
         * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
         */
        return $scope.setReady = () => {
            if ($scope.bulk_purchase) {
                $scope.booking_item.setBulkPurchase($scope.bulk_purchase);
                return true;
            } else {
                return false;
            }
        };
    });
