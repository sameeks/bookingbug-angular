(() => {

    angular
        .module('BBAdminDashboard')
        .directive('bbGridFilter', bbGridFilter);

    function bbGridFilter($compile, $templateCache, i18nService, gridUtil, $rootScope) {
        return {
            compile: () => {
                return {
                    pre: ($scope, $elm, $attrs, controllers) => {
                        $scope.col.updateFilters = function( filterable ){
                            $elm.children().remove();
                            if ( filterable ){
                                var template = $scope.col.filterHeaderTemplate;

                                $elm.append($compile(template)($scope));
                            }
                        };

                        $scope.initFilter = (col) => {
                            let filteredCol = col.field + ',' + col.filters[0].term;
                            $rootScope.$broadcast('bbGridFilter:changed', filteredCol)
                        }

                        $scope.$on( '$destroy', function() {
                            delete $scope.col.updateFilters;
                        });
                    },

                    post: ($scope, $elm, $attrs, controllers) => {
                        $scope.aria = i18nService.getSafeText('headerCell.aria');
                        $scope.removeFilter = function(colFilter, index){
                            colFilter.term = null;
                            //Set the focus to the filter input after the action disables the button
                            gridUtil.focus.bySelector($elm, '.ui-grid-filter-input-' + index);
                        };
                    }
                }
            }
        }
    }
})();
