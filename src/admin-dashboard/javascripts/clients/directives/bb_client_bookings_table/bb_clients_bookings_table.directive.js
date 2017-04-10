angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbClientBookingsTable', bbClientBookingsTable);

function bbClientBookingsTable($uibModal, $log, $rootScope, $timeout, $compile,
    $templateCache, ModalForm, BBModel, Dialog, AdminMoveBookingPopup, bbGridService, uiGridConstants) {
    let directive = {
        controller: 'bbAdminMemberBookingsTableCtrl',
        link,
        templateUrl: 'admin_member_bookings_table.html',
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
        let columnDefs;

        let prepareColumnDefs = () => {
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


        if(scope.options) {
            columnDefs = scope.options;
        } else {
            columnDefs = prepareColumnDefs();
        }

        scope.$watch('bookings', () => {
            if(scope.bookings && scope.bookings.length > 0) {
               renderBookings(scope.bookings);
            } else {
                scope.gridOptions.enablePaginationControls = false;
            }
        });


        let renderBookings = (bookings) => {
            scope.gridOptions.data = bookings;
            if(scope.gridOptions.data.length <= 15) {
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
            paginationPageSizes: [15],
            paginationPageSize: 15,
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

