(() => {

    angular
        .module('BBAdminDashboard')
        .directive('bbGridFilter', bbGridFilter);

    function bbGridFilter($compile, $templateCache, i18nService, gridUtil, $rootScope) {
        return {
            compile: () => {
                return {
                    pre: (scope, elem, attrs, controllers) => {
                        scope.col.updateFilters = (filterable) => {
                            elem.children().remove();
                            if (filterable){
                                let template = scope.col.filterHeaderTemplate;

                                elem.append($compile(template)(scope));
                            }
                        };

                        scope.initFilter = (col) => {
                            let filteredField = col.field;
                            let filteredTerm = col.filters[0]
                            filteredTerm.field = filteredField;
                            $rootScope.$broadcast('bbGridFilter:changed', filteredField, filteredTerm)
                        }

                        scope.$on( '$destroy', function() {
                            delete scope.col.updateFilters;
                        });
                    },

                    post: (scope, elem, attrs, controllers) => {
                        scope.aria = i18nService.getSafeText('headerCell.aria');
                        scope.removeFilter = function(colFilter, index){
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
