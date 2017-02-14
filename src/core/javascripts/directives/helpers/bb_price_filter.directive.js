// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbPriceFilter', PathSvc =>
    ({
        restrict: 'AE',
        replace: true,
        scope: false,
        require: '^?bbServices',
        templateUrl(element, attrs) {
            return PathSvc.directivePartial("_price_filter");
        },
        controller($scope, $attrs) {
            $scope.$watch('items', function (new_val, old_val) {
                if (new_val) {
                    return setPricefilter(new_val);
                }
            });

            var setPricefilter = function (items) {
                $scope.price_array = _.uniq(_.map(items, item => (item.price / 100) || 0)
                );
                $scope.price_array.sort((a, b) => a - b);
                return suitable_max();
            };

            var suitable_max = function () {
                let top_number = _.last($scope.price_array);
                let max_number = (() => {
                    switch (false) {
                        case top_number >= 1:
                            return 0;
                        case top_number >= 11:
                            return 10;
                        case top_number >= 51:
                            return 50;
                        case top_number >= 101:
                            return 100;
                        case top_number >= 1000:
                            return ( Math.ceil(top_number / 100) ) * 100;
                    }
                })();
                let min_number = 0;
                $scope.price_options = {
                    min: min_number,
                    max: max_number
                };
                return $scope.filters.price = {min: min_number, max: max_number};
            };

            $scope.$watch('filters.price.min', function (new_val, old_val) {
                if (new_val !== old_val) {
                    return $scope.filterChanged();
                }
            });

            return $scope.$watch('filters.price.max', function (new_val, old_val) {
                if (new_val !== old_val) {
                    return $scope.filterChanged();
                }
            });
        }
    })
);
