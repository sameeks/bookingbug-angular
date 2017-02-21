angular.module('BB.Controllers').controller('PackageItem',
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
            return BBModel.PackageItem.$query(company).then(package_items => $scope.packages = package_items);
        };


        /***
         * @ngdoc method
         * @name selectItem
         * @methodOf BB.Directives:bbPackageItems
         * @description
         * Select a package into the current booking journey and route on to the next page dpending on the current page control
         *
         * @param {object} package The Service or BookableItem to select
         * @param {string=} route A specific route to load
         */
        $scope.selectItem = function (item, route) {
            if ($scope.$parent.$has_page_control) {
                $scope.package = item;
                return false;
            } else {
                $scope.booking_item.setPackageItem(item);
                $scope.decideNextPage(route);
                return true;
            }
        };


        /***
         * @ngdoc method
         * @name setReady
         * @methodOf BB.Directives:bbPackageItems
         * @description
         * Set this page section as ready - see {@link BB.Directives:bbPage Page Control}
         */
        $scope.setReady = function () {
            if ($scope.package) {
                $scope.booking_item.setPackageItem($scope.package);
                return true;
            } else {
                return false;
            }
        };


        /***
         * @ngdoc method
         * @name getPackageServices
         * @methodOf BB.Directives:bbPackageItems
         * @description
         * Query all of the services included in the package
         * @params {array} item.service_list an array of services within the item
         */
        return $scope.getPackageServices = function (item) {
            if (item && !item.service_list) {
                item.service_list = [];
                let promise = BBModel.PackageItem.$getPackageServices(item);
                promise.then(services => item.service_list = services);
                return true;
            } else {
                return false;
            }
        };
    });
