/***
 * @ngdoc directive
 * @name BBAdminDashboard.check-in.directives:bbCheckIn
 * @restrict AE
 * @replace false
 * @scope true
 *
 * @description
 *
 * Intitialises and handles a table for appointment check-ins
 *
 * <pre>
 * restrict: 'AE'
 * replace: false
 * scope: true
 * </pre>
 */

(function () {

    angular
        .module('BBAdminDashboard.check-in.directives')
        .directive('bbCheckIn', bbCheckIn);

    function bbCheckIn(bbGridService, uiGridConstants, ClientCheckInOptions) {
        const directive = {
            restrict: 'AE',
            replace: false,
            scope: {
                options: '=',
                bb: '=',
            },
            templateUrl: 'check-in/checkin-table.html',
            controller: 'bbCheckInController',
            controllerAs: '$bbCheckInController',
            link
        };

        return directive;

        function link(scope, element, attrs) {


            const initGrid = () => {
                setPaginationOptions();
                setGridApiOptions();
                setDisplayOptions();

                scope.gridOptions = Object.assign(
                    {},
                    ClientCheckInOptions.basicOptions,
                    this.gridApiOptions,
                    this.gridDisplayOptions
                );
            };

            const setPaginationOptions = () => {
                scope.paginationOptions = {
                    pageNumber: 1,
                    pageSize: ClientCheckInOptions.paginationPageSize,
                    sort: null
                };
            };

            const setGridApiOptions = () => {
                this.gridApiOptions = {
                    onRegisterApi: (gridApi) => {
                        scope.gridApi = gridApi;
                        scope.gridData = scope.getAppointments();
                        gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                            scope.paginationOptions.pageNumber = newPage;
                            scope.paginationOptions.pageSize = pageSize;
                            scope.getAppointments(scope.paginationOptions.pageNumber + 1, null, null, null, null, true);
                        });

                        initWatchGridResize();
                    }
                };
            };

            const setDisplayOptions = () => {
                this.gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientCheckInOptions.displayOptions)};
                bbGridService.setScrollBars(ClientCheckInOptions);

            };


            const initWatchGridResize = () => {
                scope.gridApi.core.on.gridDimensionChanged(scope, () => {
                    scope.gridApi.core.handleWindowResize();
                });
            };

            initGrid();
        }
    }

})();


