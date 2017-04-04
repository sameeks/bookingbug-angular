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
        let prepareColumnDefs = () => {
            return [
                { displayName: 'Data/Time', field: 'client_name'},
                { displayName: 'Description', field: 'person_name'}
            ]
        }

        let columnDefs = prepareColumnDefs();

        scope.gridOptions = {
            enableSorting: true,
            columnDefs: bbGridService.readyColumns(columnDefs),
            onRegisterApi: function(gridApi) {
                scope.gridApi = gridApi;
            }
        }
    }
}

