angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbClientBookingsTable', bbClientBookingsTable);

function bbClientBookingsTable(bbGridService, uiGridConstants) {
    let directive = {
        controller: 'bbClientBookingsTableCtrl',
        link,
        templateUrl: 'clients/client_booking_table.html',
        scope: {
            member: '=',
            startDate: '=?',
            startTime: '=?',
            endDate: '=?',
            endTime: '=?',
            period: '@',
            options: '='
        }
    }

    return directive;

    function link(scope, elem, attrs) {

        let buildColumnsDisplay = () => {
            return [
                { displayName: 'Data/Time', field: 'datetime', cellFilter: 'datetime: "ddd DD MMM YY h.mma"', width: '25%'},
                { displayName: 'Description', field: 'details', width: '65%'},
                {  // DETAILS BUTTON COLUMN
                    field: 'detailsCell',
                    displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                    width: '10%',
                    cellTemplate: 'bookings_table_action_button.html'
                }
            ]
        }

        // you can optionally pass in some column display options to the directive scope
        let columnDefs = scope.options ? scope.options : buildColumnsDisplay();


        scope.$watch('bookings', () => {
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


        scope.gridOptions = {
            enableHorizontalScrollbar: uiGridConstants.scrollbars.NEVER,
            enableVerticalScrollbar: uiGridConstants.scrollbars.NEVER,
            enableRowSelection: true,
            enableFullRowSelection: true,
            enableRowHeaderSelection: false,
            columnDefs: bbGridService.readyColumns(columnDefs),
            enableColumnMenus: false,
            enableSorting: true,
            paginationPageSizes: [10],
            paginationPageSize: 10,
            rowHeight: 50,
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                gridApi.selection.on.rowSelectionChanged(scope, (row) => {
                    scope.edit(row.entity.id);
                });
            }
        }
    }
}

