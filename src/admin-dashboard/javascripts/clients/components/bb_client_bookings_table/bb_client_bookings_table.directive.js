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

    function bbClientBookingsTable($timeout, bbGridService, uiGridConstants, ClientBookingsTableOptions, $rootScope) {
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
                tabset: '='
            }
        }

        return directive;

        function link(scope, elem, attrs) {

            scope.$watch('tabset.active', () => {
                $timeout(() => {
                    // we need to only show a grid if its tab is active
                    // otherwise ui-grid will not know what size it should be and would display incorrectly
                    // http://ui-grid.info/docs/#/tutorial/108_hidden_grids
                    scope.activeGrid = scope.tabset.active;
                });
            });

            let killWatch = scope.$watch('bookings', () => {
                scope.gridOptions.data = scope.bookings;
            });


            let initGrid = () => {

                let gridDisplayOptions = {columnDefs: bbGridService.setColumns(ClientBookingsTableOptions.displayOptions)};

                bbGridService.setScrollBars(ClientBookingsTableOptions);

                let gridApiOptions = {
                    onRegisterApi: (gridApi) => {
                        scope.gridApi = gridApi;
                        gridApi.selection.on.rowSelectionChanged(scope, (row) => {
                            scope.edit(row.entity.id);
                        });

                        initWatchGridResize()
                    }
                }

                scope.gridOptions = Object.assign(
                    {},
                    ClientBookingsTableOptions.basicOptions,
                    gridApiOptions,
                    gridDisplayOptions
                )
            }

            let initWatchGridResize = () => {
                console.log("initWatchGridResize")
                scope.gridApi.core.on.gridDimensionChanged(scope, () => {
                    console.log("dimensinos changed")
                    scope.gridApi.core.handleWindowResize();
                });
            }

            initGrid();
        }
    }

})();

