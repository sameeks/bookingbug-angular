angular
    .module('BBAdminBooking')
    .directive('bbAdminMemberBookingsTable', bbAdminMemberBookingsTable);

function bbAdminMemberBookingsTable($uibModal, $log, $rootScope, $compile, $templateCache, ModalForm, BBModel, Dialog, AdminMoveBookingPopup) {
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
                { displayName: 'Desctription', field: 'person_name'}
            ]
        }

        let prepareCustomGridOptions = () => {
            let columnDefs = prepareColumnDefs();
             // make header cells translatable
            for(let col of columnDefs) {
                col.headerCellFilter = 'translate';
            }

            return columnDefs;
        }

        scope.gridOptions = {
            enableSorting: true,
            columnDefs: prepareCustomGridOptions(),
            onRegisterApi: function(gridApi) {
                scope.gridApi = gridApi;
            }
        }
    }
}

