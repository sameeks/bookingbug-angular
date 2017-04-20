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

(() => {

    angular
        .module('BBAdminDashboard.check-in.directives')
        .directive('bbCheckIn', bbCheckIn);

    function bbCheckIn(bbGridService, uiGridConstants, ClientCheckInOptions) {
        let directive = {
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
        }

        return directive;

        function link(scope, element, attrs) {

            let initGrid = () => {

                let gridDisplayOptions = {columnDefs: bbGridService.readyColumns(ClientCheckInOptions.displayOptions)};

                scope.paginationOptions = {
                    pageNumber: 1,
                    pageSize: ClientCheckInOptions.paginationPageSize,
                    sort: null
                }

                let gridApiOptions = {
                    onRegisterApi: (gridApi) => {
                        scope.gridApi = gridApi;
                        scope.gridData = scope.getAppointments();
                        gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                            scope.paginationOptions.pageNumber = newPage;
                            scope.paginationOptions.pageSize = pageSize;
                            scope.getAppointments(scope.paginationOptions.pageNumber + 1, null, null, null, null, true);
                        });
                    }
                }

                if(ClientCheckInOptions.basicOptions.disableScrollBars) {
                    ClientCheckInOptions.basicOptions.enableHorizontalScrollbar = uiGridConstants.scrollbars.NEVER;
                    ClientCheckInOptions.basicOptions.enableVerticalScrollbar = uiGridConstants.scrollbars.NEVER;
                }

                scope.gridOptions = Object.assign(
                    {},
                    ClientCheckInOptions.basicOptions,
                    gridApiOptions,
                    gridDisplayOptions
                )
            }

            initGrid();
        }
    }

})();


