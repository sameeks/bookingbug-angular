// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbAttendees', () =>
    ({
        restrict: 'AE',
        replace: true,
        scope: true,
        controller($scope, $rootScope, $q, PurchaseService, AlertService, ValidatorService, LoadingService, BBModel) {

            let loader = LoadingService.$loader($scope);

            $rootScope.connection_started.then(() => initialise());


            var initialise = () => $scope.items = $scope.bb.basket.timeItems();


            let updateBooking = function () {

                let deferred = $q.defer();

                let params = {
                    purchase: $scope.bb.moving_purchase,
                    bookings: $scope.bb.basket.items,
                    notify: true
                };
                PurchaseService.update(params).then(function (purchase) {
                        $scope.bb.purchase = purchase;
                        loader.setLoaded();
                        $scope.bb.current_item.move_done = true;
                        $rootScope.$broadcast("booking:updated");
                        return deferred.resolve();
                    }
                    , err => deferred.reject());

                return deferred.promise;
            };


            /***
             * @ngdoc method
             * @name markItemAsChanged
             * @methodOf BB.Directives:bbAttendees
             * @description
             * Call this when an attendee is changed
             */
            $scope.markItemAsChanged = item => item.attendee_changed = true;


            /***
             * @ngdoc method
             * @name updateBooking
             * @methodOf BB.Directives:bbAttendees
             * @description
             * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
             */
            $scope.changeAttendees = function () {

                if (!$scope.bb.current_item.ready || !$scope.bb.moving_purchase) {
                    return false;
                }

                let deferred = $q.defer();

                loader.notLoaded();

                let client_promises = [];

                for (var item of Array.from($scope.items)) {

                    if (item.attendee_changed) {

                        let client = new BBModel.Client();
                        client.first_name = item.first_name;
                        client.last_name = item.last_name;

                        client_promises.push(BBModel.Client.$create_or_update($scope.bb.company, client));

                    } else {

                        client_promises.push($q.when([]));
                    }
                }


                $q.all(client_promises).then(function (result) {

                    for (let index = 0; index < $scope.items.length; index++) {
                        item = $scope.items[index];
                        if (result[index] && result[index].id) {
                            item.client_id = result[index].id;
                        }
                    }

                    return updateBooking().then(function () {
                            if ($scope.$parent.$has_page_control) {
                                return deferred.resolve();
                            } else {
                                $scope.decideNextPage('purchase');
                                AlertService.raise('ATTENDEES_CHANGED');
                                return deferred.resolve();
                            }
                        }
                        , err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong'));
                });

                return deferred.promise;
            };


            /***
             * @ngdoc method
             * @name setReady
             * @methodOf BB.Directives:bbAttendees
             * @description
             * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
             */
            return $scope.setReady = () => $scope.changeAttendees();
        }
    })
);
