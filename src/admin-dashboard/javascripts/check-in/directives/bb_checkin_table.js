(() => {

    angular
        .module('BBAdminDashboard.check-in.directives')
        .directive('bbCheckinTable', bbCheckinTable);

    function bbCheckinTable(AdminCheckInOptions, $translate) {
        let directive = {
            restrict: 'AE',
            replace: false,
            scope: true,
            templateUrl: 'check-in/checkin-table.html',
            controller: 'CheckinsController',
            link
        }

        return directive;

        function link(scope, element, attrs) {

            let prepareColumnDefs = () => {
                return [
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.CUSTOMER', field: 'client_name'},
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.STAFF_MEMBER', field: 'person_name'},
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.DUE', field: 'datetime'},
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.NO_SHOW', field: 'multi_status.no_show'},
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.ARRIVED', field: 'multi_status.arrived'},
                    { displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.BEING_SEEN', field: 'multi_status.beeing_seen'}
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
                    scope.getAppointments(null, null, null, null, null, true);
                }
            }
        }
    }

})();


