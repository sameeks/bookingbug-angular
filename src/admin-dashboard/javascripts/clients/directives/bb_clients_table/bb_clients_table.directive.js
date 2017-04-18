(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientsTable', BBClientsTable);

    function BBClientsTable(bbGridService, uiGridConstants, $state, $filter) {
        let directive = {
            link,
            restrict: 'AE',
            replace: true,
            scope: {
                company: '=',
                options: '='
            },
            controller: 'TabletClients',
            templateUrl: 'clients/client_grid.html'
        }

        return directive;

        function link(scope, element, attrs) {
            let filters = [];
            let filterString;

            let buildColumnsDisplay = () => {
                return [
                    { field: 'name', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.NAME', width: '35%' },
                    { field: 'email', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.EMAIL', width: '35%' },
                    { field: 'mobile', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.MOBILE', width: '25%', cellFilter: 'local_phone_number: mobile' },
                    {  // ACTION BUTTON COLUMN
                        field: 'action',
                        displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                        enableFiltering: false,
                        width: '5%',
                        headerCellClass: 'action-column-header',
                        enableSorting: false,
                        enableColumnMenus: false,
                        cellTemplate: 'clients/action.html'
                    }
                ]
            }


            // you can optionally pass in some column display options to the directive scope
            let columnDefs = scope.options ? scope.options : buildColumnsDisplay();


            let buildFilterString = (filters) => {
                filterString = $filter('buildClientString')(filters);
                scope.getClients(scope.paginationOptions.pageNumber, filterString);
            }


            let handleFilterChange = (filterObject) => {
                let builtFilters = $filter('buildClientFieldsArray')(filters, filterObject);
                buildFilterString(builtFilters);
            }

            scope.paginationOptions = {
                pageNumber: 1,
                pageSize: 15,
                sort: null
            }

            scope.gridOptions = {
                columnDefs: bbGridService.readyColumns(columnDefs),
                enableColumnMenus: false,
                enableFiltering: true,
                enableFullRowSelection: true,
                enableHorizontalScrollbar: uiGridConstants.scrollbars.NEVER,
                enableRowSelection: true,
                enableRowHeaderSelection: false,
                enableSorting: true,
                enableVerticalScrollbar: uiGridConstants.scrollbars.NEVER,
                paginationPageSize: 15,
                paginationPageSizes: [15],
                rowHeight: 40,
                useExternalPagination: true,
                onRegisterApi: (gridApi) => {
                    scope.gridApi = gridApi;
                    scope.gridData = scope.getClients();
                    gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                        scope.paginationOptions.pageNumber = newPage;
                        scope.paginationOptions.pageSize = pageSize;
                        scope.getClients(scope.paginationOptions.pageNumber + 1, filterString);
                    });
                    // adds ability to edit a client by clicking on their row rather than just the action button
                    gridApi.selection.on.rowSelectionChanged(scope, (row) => {
                        $state.go('clients.edit', {id: row.entity.id});
                    });
                }
            }

            // fire a custom event when filter changes
            // ui-grid doesnt pass the filtered data through to the event it broadcasts
            scope.$on('bbGridFilter:changed', (event, filterObject) => {
                if(filters.length === 0) {
                    filters.push(filterObject);
                    buildFilterString(filters);
                } else {
                   handleFilterChange(filterObject);
                }
            });
        }
    };


})();

