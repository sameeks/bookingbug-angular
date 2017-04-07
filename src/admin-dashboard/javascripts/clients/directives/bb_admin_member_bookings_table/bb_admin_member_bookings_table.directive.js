angular
    .module('BBAdminDashboard.clients.directives')
    .directive('bbAdminMemberBookingsTable', bbAdminMemberBookingsTable);

function bbAdminMemberBookingsTable($uibModal, $log, $rootScope, $compile, $templateCache, ModalForm, BBModel, Dialog, AdminMoveBookingPopup, bbGridService) {
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
            period: '@'
        }
    }

    return directive;

    function link(scope, elem, attrs) {

        let prepareColumnDefs = () => {
            return [
                { displayName: 'Data/Time', field: 'datetime', cellFilter: 'datetime: "ddd DD MMM YY h.mma"'},
                { displayName: 'Description', field: 'details'},
                {  // DETAILS BUTTON COLUMN
                    field: 'detailsCell',
                    displayName: '',
                    width: 80,
                    cellTemplate: 'bookings_table_action_button.html'
                }
            ]
        }

        scope.$watch('bookings', () => {
            if(scope.bookings && scope.bookings.length > 0) {
               renderBookings(scope.bookings);
            }
        });

        let renderBookings = (bookings) => {
           setGridOptions(bookings);
        }

        let columnDefs = prepareColumnDefs();

        scope.gridOptions = {
            columnDefs: bbGridService.readyColumns(columnDefs),
            enableColumnMenus: false,
            enableSorting: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
        }

        let setGridOptions = (bookings) => {
            scope.gridOptions = {
                data: bookings,
                onRegisterApi: (gridApi) => {
                    scope.gridApi = gridApi;
                }
            }
        }
    }
}

