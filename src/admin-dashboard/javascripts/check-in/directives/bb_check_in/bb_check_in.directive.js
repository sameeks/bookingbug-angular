angular
    .module('BBAdminDashboard.check-in.directives')
    .directive('bbCheckIn', bbCheckIn);

function bbCheckIn(bbGridService) {
    let directive = {
        restrict: 'AE',
        replace: false,
        scope: {
            options: '=',
            bb: '=',
            api_url: '=',
            company: '='
        },
        templateUrl: 'check-in/checkin-table.html',
        controller: 'bbCheckInController',
        link
    }

    return directive;

    function link(scope, element, attrs) {
        let columnDefs;

        let prepareColumnDefs = () => {
            return [
                { displayName: '-', field: 'test', cellTemplate: 'check-in/_edit_cell.html'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.CUSTOMER', field: 'client_name'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.STAFF_MEMBER', field: 'person_name'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.DUE', field: 'datetime', cellFilter: 'datetime:"LT"'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.NO_SHOW', field: 'multi_status.no_show', cellFilter: 'datetime:"LT"', cellTemplate: 'check-in/_no_show.html'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.ARRIVED', field: 'multi_status.arrived', cellFilter: 'datetime:"LT"', cellTemplate: 'check-in/_arrival_cell.html'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.BEING_SEEN', field: 'multi_status.being_seen', cellTemplate: 'check-in/_being_seen_cell.html'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.COMPLETED', field: 'multi_status.being_seen', cellTemplate: 'check-in/_completed_cell.html'}
            ]
        }

        if(scope.options) {
            columnDefs = scope.options;
        } else {
            columnDefs = prepareColumnDefs();
        }

        scope.gridOptions = {
            enableSorting: true,
            rowHeight: 40,
            columnDefs: bbGridService.readyColumns(columnDefs),
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                scope.getAppointments(null, null, null, null, null, true);
            }
        }
    }
}


