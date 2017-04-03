(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientsTable', BBClientsTable);

    function BBClientsTable() {
        let directive = {
            link,
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'TabletClients'
        }

        return directive;

        function link(scope, element, attrs) {

            scope.actionButton = `<a class="btn btn-xs btn-default" ui-sref="clients.edit({id: row.entity.id})"><i class="fa fa-pencil"></i>
              <span translate="ADMIN_DASHBOARD.CLIENTS_PAGE.EDIT"></span></a>`;

            scope.paginationOptions = {
                pageNumber: 1,
                pageSize: 15,
                sort: null
            }

            scope.$on('bbGridFilter:changed', (event, field) => {
                scope.getClients(scope.paginationOptions.pageNumber + 1, field);
            });


            this.columns =
                [
                    {name: 'Name', field: 'name', filterHeaderTemplate: 'ui_grid_filter_template.html', headerCellTemplate: 'ui_grid_header_template.html'},
                    {name: 'Email', field: 'email', filterHeaderTemplate: 'ui_grid_filter_template.html', headerCellTemplate: 'ui_grid_header_template.html'},
                    {name: 'Mobile', field: 'mobile', filterHeaderTemplate: 'ui_grid_filter_template.html', headerCellTemplate: 'ui_grid_header_template.html'},
                    {name: 'Actions', field: 'action', enableFiltering: false, enableHiding: false, enableSorting: false, enableColumnMenus: false, cellTemplate: scope.actionButton}
                ]

            scope.$on('gridFilter:changed', (event, field) => {
                scope.getClients(scope.paginationOptions + 1, field);
            });

            scope.gridOptions = {
                enableSorting: true,
                enableFiltering: true,
                paginationPageSizes: [15],
                paginationPageSize: 15,
                useExternalPagination: true,
                columnDefs: this.columns,
                onRegisterApi: function(gridApi) {
                    scope.gridApi = gridApi;
                    scope.gridData = scope.getClients();
                    gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                        let filteredRows = gridApi.core.getVisibleRows(scope.gridApi.grid);
                        scope.paginationOptions.pageNumber = newPage;
                        scope.paginationOptions.pageSize = pageSize;
                        scope.getClients(scope.paginationOptions.pageNumber + 1, null);
                    })
                }
            }
        }
    };
})();


