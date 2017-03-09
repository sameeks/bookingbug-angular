angular.module('BB.Controllers').controller('TimeSlots',
    function ($scope, $rootScope, $q, $attrs, FormDataStoreService, ValidatorService, LoadingService, halClient, BBModel) {

        let loader = LoadingService.$loader($scope).notLoaded();
        $rootScope.connection_started.then(
            function () {
                if ($scope.bb.company) {
                    return $scope.init($scope.bb.company);
                }
            },
            err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
        );

        $scope.init = function (company) {
            if (!$scope.booking_item) {
                $scope.booking_item = $scope.bb.current_item;
            }
            $scope.start_date = moment();
            $scope.end_date = moment().add(1, 'month');

            let params = {
                item: $scope.booking_item,
                start_date: $scope.start_date.toISODate(),
                end_date: $scope.end_date.toISODate()
            };
            return BBModel.Slot.$query($scope.bb.company, params).then(
                function (slots) {
                    $scope.slots = slots;
                    return loader.setLoaded();
                },
                err => loader.setLoadedAndShowError(err, 'Sorry, something went wrong')
            );
        };

        let setItem = slot => $scope.booking_item.setSlot(slot);

        /***
         * @ngdoc method
         * @name selectItem
         * @methodOf BB.Directives:bbTimeSlots
         * @description
         * Select an item into the current booking journey and route on to the next page dpending on the current page control
         *
         * @param {object} slot The slot from list
         * @param {string=} route A specific route to load
         */
        return $scope.selectItem = function (slot, route) {
            if ($scope.$parent.$has_page_control) {
                setItem(slot);
                return false;
            } else {
                setItem(slot);
                $scope.decideNextPage(route);
                return true;
            }
        };
    });
