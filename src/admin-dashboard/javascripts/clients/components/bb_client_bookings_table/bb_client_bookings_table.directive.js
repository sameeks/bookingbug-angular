/***
 * @ngdoc directive
 * @name BBAdminDashboard.clients.directives:bbClientBookingsTable
 * @scope true
 *
 * @description
 *
 * Intitialises and handles a table for a specific client's booking data
 *
 * <pre>
 * scope: true
 * </pre>
 */

(() => {

    angular
        .module('BBAdminDashboard.clients.directives')
        .directive('bbClientBookingsTable', bbClientBookingsTable);

    function bbClientBookingsTable($timeout, bbGridService, uiGridConstants, ClientBookingsTableOptions) {
        let directive = {
            controller: 'bbClientBookingsTableCtrl',
            link,
            templateUrl: 'clients/bookings_table.html',
            scope: {
                member: '=',
                startDate: '=?',
                startTime: '=?',
                endDate: '=?',
                endTime: '=?',
                period: '@',
                options: '=',
                tabset: '='
            }
        }

        return directive;

        function link(scope, elem, attrs) {

            scope.$watch('tabset.active', () => {
                $timeout(() => {
                    scope.activeGrid = scope.tabset.active;
                });
            });

            let killWatch = scope.$watch('bookings', () => {
                if(scope.bookings && scope.bookings.length > 0) {
                   renderBookings(scope.bookings);
                   scope.gridOptions.enablePaginationControls = true;
                }
            });


            let renderBookings = (bookings) => {
                scope.gridOptions.data = bookings;
                if(scope.gridOptions.data.length <= 10) {
                    scope.gridOptions.enablePaginationControls = false;
                }
            }


            let initGrid = () => {

                let columnDefs = ClientBookingsTableOptions.displayOptions;

                let gridDisplayOptions = {columnDefs: bbGridService.readyColumns(ClientBookingsTableOptions.displayOptions)};

                if(ClientBookingsTableOptions.basicOptions.disableScrollBars) {
                    ClientBookingsTableOptions.basicOptions.enableHorizontalScrollbar = uiGridConstants.scrollbars.NEVER;
                    ClientBookingsTableOptions.basicOptions.enableVerticalScrollbar = uiGridConstants.scrollbars.NEVER;
                }

                let gridApiOptions = {
                    onRegisterApi: (gridApi) => {
                        scope.gridApi = gridApi;
                        gridApi.selection.on.rowSelectionChanged(scope, (row) => {
                            scope.edit(row.entity.id);
                        });
                    }
                }

                scope.gridOptions = Object.assign(
                    {},
                    ClientBookingsTableOptions.basicOptions,
                    gridApiOptions,
                    gridDisplayOptions
                )
            }

            initGrid();
        }
    }

})();

