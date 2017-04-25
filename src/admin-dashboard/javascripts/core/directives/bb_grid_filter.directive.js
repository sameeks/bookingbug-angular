(function () {

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
                            const filteredField = {
                                fieldName: col.field,
                                value: col.filters[0].term,
                                id: col.uid
                            };

                            $rootScope.$broadcast('bbGridFilter:changed', filteredField);
                        };

                        scope.$on( '$destroy', () => {
                            delete scope.col.updateFilters;
                        });
                    },

                    post: (scope, elem, attrs, controllers) => {
                        scope.aria = i18nService.getSafeText('headerCell.aria');
                        scope.removeFilter = (colFilter, index) => {
                            colFilter.term = null;
                            //Set the focus to the filter input after the action disables the button
                            gridUtil.focus.bySelector($elm, '.ui-grid-filter-input-' + index);
                        };
                    }
                };
            }
        };
    }
})();
