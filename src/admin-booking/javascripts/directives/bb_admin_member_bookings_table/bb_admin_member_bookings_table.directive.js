angular
    .module('BBAdminBooking')
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

        scope.detailsButton = `<button class="btn btn-default btn-sm ng-scope" ng-click="grid.appScope.edit(row.entity.id)" translate="ADMIN_BOOKING.BOOKINGS_TABLE.DETAILS_BTN">Details</button>`


        let prepareColumnDefs = () => {
            return [
                { displayName: 'Data/Time', field: 'datetime', cellFilter: 'datetime: "ddd DD MMM YY h.mma"'},
                { displayName: 'Description', field: 'details'},
                {  // DETAILS BUTTON COLUMN
                    field: 'detailsCell',
                    displayName: '',
                    width: 80,
                    cellTemplate: scope.detailsButton
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
            columnDefs: bbGridService.readyColumns(columnDefs)
        }

        let setGridOptions = (bookings) => {
            scope.gridOptions = {
                data: bookings,
                enableSorting: true,
                columnDefs: bbGridService.readyColumns(columnDefs),
                onRegisterApi: (gridApi) => {
                    scope.gridApi = gridApi;
                }
            }
        }
    }
}

