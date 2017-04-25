/***
 * @ngdoc directive
 * @name BBAdminDashboard.clients.directives:bbClientsTable
 * @scope true
 *
 * @description
 *
 * Intitialises and handles a table for client data
 *
 * <pre>
 * restrict: 'AE'
 * replace: true
 * scope: true
 * </pre>
 */

(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientsTable', BBClientsTable);

    function BBClientsTable(bbGridService, uiGridConstants, $state, $filter, ClientTableOptions, $rootScope) {
        let directive = {
            link,
            restrict: 'AE',
            replace: true,
            scope: {
                company: '=',
                options: '='
            },
            controller: 'bbClientsTableCtrl',
            templateUrl: 'clients/clients_table.html'
        }

        return directive;

        function link(scope, elem, attrs) {
            let filters = [];
            let filterString;

            let initGrid = () => {

                scope.paginationOptions = {
                    pageNumber: 1,
                    pageSize: ClientTableOptions.basicOptions.paginationPageSize,
                    sort: null
                }

                let gridApiOptions = {
                    onRegisterApi: (gridApi) => {
                        scope.gridApi = gridApi;
                        scope.gridData = scope.getClients();
                        gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                            scope.paginationOptions.pageNumber = newPage;
                            scope.paginationOptions.pageSize = pageSize;
                            scope.getClients(scope.paginationOptions.pageNumber, filterString);
                        });
                        // adds ability to edit a client by clicking on their row rather than just the action button
                        gridApi.selection.on.rowSelectionChanged(scope, (row) => {
                            $state.go('clients.edit', {id: row.entity.id});
                        });

                        initWatchGridResize();
                    }
                }

                let gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientTableOptions.displayOptions)};

                bbGridService.setScrollBars(ClientTableOptions);

                scope.gridOptions = Object.assign(
                    {},
                    ClientTableOptions.basicOptions,
                    gridApiOptions,
                    gridDisplayOptions
                )
            }

            let initWatchGridResize = () => {
                scope.gridApi.core.on.gridDimensionChanged(scope, () => {
                    scope.gridApi.core.handleWindowResize();
                });
            }

            let buildFilterString = (filters) => {
                filterString = $filter('buildClientString')(filters);
                scope.getClients(scope.paginationOptions.pageNumber, filterString);
            }


            let handleFilterChange = (filterObject) => {
                let builtFilters = $filter('buildClientFieldsArray')(filters, filterObject);
                buildFilterString(builtFilters);
            }

            scope.$on('bbGridFilter:changed', (event, filterObject) => {
                if(filters.length === 0) {
                    filters.push(filterObject);
                    buildFilterString(filters);
                } else {
                   handleFilterChange(filterObject);
                }
            });

            initGrid()
        }
    };
})();

