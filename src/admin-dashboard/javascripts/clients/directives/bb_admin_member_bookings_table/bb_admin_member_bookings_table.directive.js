angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbAdminMemberBookingsTable', bbAdminMemberBookingsTable);

function bbAdminMemberBookingsTable($uibModal, $log, $rootScope, $timeout, $compile, $templateCache, ModalForm, BBModel, Dialog, AdminMoveBookingPopup, bbGridService) {
    let directive = {
        controller: 'bbAdminMemberBookingsTableCtrl',
        link,
        templateUrl: 'admin_member_bookings_table.html',
        scope: {
            apiUrl: '@',
            fields: '=?',
            member: '=',
            startDate: '=?',
            startTime: '=?',
            endDate: '=?',
            endTime: '=?',
            defaultOrder: '=?',
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
            }
        });


        let renderBookings = (bookings) => {
            setGridOptions(bookings);
            $timeout(() => {
                scope.gridApi.core.handleWindowResize();
            }, 100);
        }


        scope.gridOptions = {
            columnDefs: bbGridService.readyColumns(columnDefs),
            enableColumnMenus: false,
            enableSorting: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 50,
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                scope.gridApi.core.handleWindowResize();
            }
        }

        let setGridOptions = (bookings) => {
            scope.gridOptions.data = bookings;
        }
    }
}

