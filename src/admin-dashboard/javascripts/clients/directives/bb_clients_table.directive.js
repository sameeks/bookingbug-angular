
angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbClientsTable', BBClientsTable);

function BBClientsTable(bbGridService) {
    let directive = {
        link,
        restrict: 'AE',
        replace: true,
        scope: true,
        controller: 'TabletClients'
    }

    return directive;

    function link(scope, element, attrs) {
        let filters = [];
        let customTemplates = {filterHeaderTemplate: 'ui_grid_filter_template.html', headerCellTemplate: 'ui_grid_header_template.html'}

        let prepareColumnDefs = () => {
            return [
                { field: 'name', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.NAME' },
                { field: 'email', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.EMAIL' },
                { field: 'mobile', displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.MOBILE' },
                {  // ACTION BUTTON COLUMN
                    field: 'action',
                    displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                    enableFiltering: false,
                    enableHiding: false,
                    enableSorting: false,
                    enableColumnMenus: false,
                    cellTemplate: 'clients/action.html'
                }
            ]
        }


        let columnDefs = prepareColumnDefs();

        scope.paginationOptions = {
            pageNumber: 1,
            pageSize: 15,
            sort: null
        }

        scope.gridOptions = {
            enableSorting: true,
            enableFiltering: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            useExternalPagination: true,
            enableColumnMenus: false,
            columnDefs: bbGridService.readyColumns(columnDefs, customTemplates),
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                scope.gridData = scope.getClients();
                gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                    scope.paginationOptions.pageNumber = newPage;
                    scope.paginationOptions.pageSize = pageSize;
                    scope.getClients(scope.paginationOptions.pageNumber + 1, this.filterString);
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

        let buildFilterString = (filters) => {
            // we need to build a string in format "field,value,field,value,field,value"
            this.filterString = bbGridService.formatFilterString(filters);
            scope.getClients(scope.paginationOptions.pageNumber, this.filterString);
        }


        let handleFilterChange = (filterObject) => {
            // we need to build an array of filtered fields
            // replace current object with updated filter value if that filter is already in array
            _.filter(filters, (fil) => {
                if(fil.id === filterObject.id) {
                    filters = _.without(filters, fil)
                }
            });
            if(filterObject.value !== '') {
                filters.push(filterObject);
            }

            buildFilterString(filters);
        }
    }
};


