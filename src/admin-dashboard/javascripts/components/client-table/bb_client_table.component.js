(function () {
    /***
     * @ngdoc component
     * @name BBAdminDashboard:bbClientsTable
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

    angular
        .module('BBAdminDashboard.clients.directives')
        .component('bbClientTable', {
            templateUrl: 'clients/clients_table.html',
            controller: bbClientsTableCtrl,
            controllerAs: '$bbClientsTableCtrl',
            bindings: {
                options: '=',
                company: '='
            }
        });


    function bbClientsTableCtrl($scope, bbGridService, uiGridConstants, $state, $filter, ClientTableOptions, $rootScope, ClientTableService) {

        let filters = [];
        let filterString;

        const initGrid = () => {
            setPaginationOptions();
            setGridApiOptions();
            setDisplayOptions();

            $scope.gridOptions = Object.assign(
                {},
                ClientTableOptions.basicOptions,
                this.gridApiOptions,
                this.gridDisplayOptions
            );
        };

        const setPaginationOptions = () => {
            $scope.paginationOptions = {
                pageNumber: 1,
                pageSize: ClientTableOptions.basicOptions.paginationPageSize,
                sort: null
            };
        };

        const setGridApiOptions = () => {
            this.gridApiOptions = {
                onRegisterApi: (gridApi) => {
                    $scope.gridApi = gridApi;
                    $scope.gridData = ClientTableService.getClients($scope.paginationOptions);
                    gridApi.pagination.on.paginationChanged($scope, (newPage, pageSize) => {
                        $scope.paginationOptions.pageNumber = newPage;
                        $scope.paginationOptions.pageSize = pageSize;
                        ClientTableService.getClients($scope.paginationOptions, filterString);
                    });
                    // adds ability to edit a client by clicking on their row rather than just the action button
                    gridApi.selection.on.rowSelectionChanged($scope, (row) => {
                        $state.go('clients.edit', {id: row.entity.id});
                    });

                    initWatchGridResize();
                }
            };
        };

        const setDisplayOptions = () => {
            this.gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientTableOptions.displayOptions)};
            bbGridService.setScrollBars(ClientTableOptions);
        };


        const initWatchGridResize = () => {
            $scope.gridApi.core.on.gridDimensionChanged($scope, () => {
                $scope.gridApi.core.handleWindowResize();
            });
        };

        const buildFilterString = (filters) => {
            filterString = $filter('buildClientString')(filters);
            ClientTableService.getClients($scope.paginationOptions, filterString);
        };


        const buildFiltersArray = (filterObject) => {
            let filtersArray = $filter('buildClientFieldsArray')(filters, filterObject);
            buildFilterString(filtersArray);
        };

        const handleFilterChange = (filterObject) => {
            if(filters.length === 0) {
                filters.push(filterObject);
                buildFilterString(filters);
            } else {
               buildFiltersArray(filterObject);
            }
        };

        $scope.$on('bbGridFilter:changed', (event, filterObject) => {
            handleFilterChange(filterObject);
        });

        initGrid();
    }
})();

