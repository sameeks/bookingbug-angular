angular
    .module('BBAdminDashboard.check-in.directives')
    .directive('bbCheckIn', bbCheckIn);

function bbCheckIn(bbGridService) {
    let directive = {
        restrict: 'AE',
        replace: false,
        scope: true,
        templateUrl: 'check-in/checkin-table.html',
        controller: 'bbCheckInController',
        link
    }

    return directive;

    function link(scope, element, attrs) {

        let prepareColumnDefs = () => {
            return [
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.CUSTOMER', field: 'client_name'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.STAFF_MEMBER', field: 'person_name'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.DUE', field: 'formatDate(datetime)'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.NO_SHOW', field: 'multi_status.no_show'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.ARRIVED', field: 'multi_status.arrived'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.BEING_SEEN', field: 'multi_status.being_seen'}
            ]
        }

        let columnDefs = prepareColumnDefs();

        scope.gridOptions = {
            enableSorting: true,
            columnDefs: bbGridService.readyColumns(columnDefs),
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                scope.getAppointments(null, null, null, null, null, true);
            }
        }
    }
}


