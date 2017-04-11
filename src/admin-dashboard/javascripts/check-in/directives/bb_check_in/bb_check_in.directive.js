angular
    .module('BBAdminDashboard.check-in.directives')
    .directive('bbCheckIn', bbCheckIn);

function bbCheckIn(bbGridService, uiGridConstants) {
    let directive = {
        restrict: 'AE',
        replace: false,
        scope: {
            options: '=',
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
                { displayName: '-', field: 'test', cellTemplate: 'check-in/_edit_cell.html', width: '5%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.CUSTOMER', field: 'client_name', width: '15%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.STAFF_MEMBER', field: 'person_name', width: '15%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.DUE', field: 'datetime', cellFilter: 'datetime:"LT"', width: '7.5%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.NO_SHOW', field: 'multi_status.no_show', cellFilter: 'datetime:"LT"', cellTemplate: 'check-in/_no_show.html', width: '15%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.ARRIVED', field: 'multi_status.arrived', cellFilter: 'datetime:"LT"', cellTemplate: 'check-in/_arrival_cell.html', width: '15%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.BEING_SEEN', field: 'multi_status.being_seen', cellTemplate: 'check-in/_being_seen_cell.html', width: '15%'},
                { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.COMPLETED', field: 'multi_status.being_seen', cellTemplate: 'check-in/_completed_cell.html', width: '15%'}
            ]
        }

        if(scope.options) {
            columnDefs = scope.options;
        } else {
            columnDefs = prepareColumnDefs();
        }

        scope.paginationOptions = {
            pageNumber: 1,
            pageSize: 15,
            sort: null
        }

        scope.gridOptions = {
            enableHorizontalScrollbar: uiGridConstants.scrollbars.NEVER,
            enableVerticalScrollbar: uiGridConstants.scrollbars.NEVER,
            enableSorting: true,
            rowHeight: 40,
            enableColumnMenus: false,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            useExternalPagination: true,
            columnDefs: bbGridService.readyColumns(columnDefs),
            onRegisterApi: (gridApi) => {
                scope.gridApi = gridApi;
                scope.gridData = scope.getAppointments();
                gridApi.pagination.on.paginationChanged(scope, (newPage, pageSize) => {
                    scope.paginationOptions.pageNumber = newPage;
                    scope.paginationOptions.pageSize = pageSize;
                    scope.getAppointments(scope.paginationOptions.pageNumber + 1, null, null, null, null, true);
                });
            }
        }
    }
}


