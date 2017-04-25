  /*
 * @ngdoc service
 * @name BBAdminDashboard.clients.services.service:AdminClientsOptions
 *
 * @description
 * Returns a set of admin calendar configuration options
 */

/*
 * @ngdoc service
 * @name BBAdminDashboard.clients.services.service:AdminClientsOptionsProvider
 *
 * @description
 * Provider
 *
 * @example
 <example>
 angular.module('ExampleModule').config ['AdminClientsOptionsProvider', (AdminClientsOptionsProvider) ->
 AdminClientsOptionsProvider.setOption('option', 'value')
 ]
 </example>
 */
angular.module('BBAdminDashboard.clients.services').provider('ClientCheckInOptions', [function () {
    let options = {
        paginationPageSize: 15,
        disableScrollBars: true,
        basicOptions: {
            enableSorting: true,
            rowHeight: 40,
            enableColumnMenus: true,
            paginationPageSizes: [15],
            useExternalPagination: true
        },
        displayOptions: [
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.EDIT',
                field: 'test',
                cellTemplate: 'check-in/_edit_cell.html',
                width: '5%',
                enableColumnMenu: false
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.CUSTOMER',
                field: 'client_name',
                width: '15%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.STAFF_MEMBER',
                field: 'person_name',
                width: '15%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.DUE',
                field: 'datetime',
                cellFilter: 'datetime:"LT"',
                width: '7.5%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.NO_SHOW',
                field: 'multi_status.no_show',
                cellFilter: 'datetime:"LT"',
                cellTemplate: 'check-in/_no_show.html',
                width: '15%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.ARRIVED',
                field: 'multi_status.arrived',
                cellFilter: 'datetime:"LT"',
                cellTemplate: 'check-in/_arrival_cell.html',
                width: '15%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.BEING_SEEN',
                field: 'multi_status.being_seen',
                cellTemplate: 'check-in/_being_seen_cell.html',
                width: '15%'
            },
            {
                displayName: 'ADMIN_DASHBOARD.CHECK_IN_PAGE.COMPLETED',
                field: 'multi_status.being_seen',
                cellTemplate: 'check-in/_completed_cell.html',
                width: '15%'
            }
        ]
    };

    this.setOption = function (option, value) {
        if (options.hasOwnProperty(option)) {
            options[option] = value;
        }
    };

    this.getOption = function (option) {
        if (options.hasOwnProperty(option)) {
            return options[option];
        }
    };
    this.$get = () => options;

}
]);
