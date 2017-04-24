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
angular.module('BBAdminDashboard.clients.services').provider('ClientTableOptions', [function () {
    let options = {
        basicOptions: {
            enableColumnMenus: true,
            enableFiltering: true,
            enableFullRowSelection: true,
            enableRowHeaderSelection: false,
            enableRowSelection: true,
            enableSorting: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 40,
            useExternalPagination: true
        },
        displayOptions: [
            {
                field: 'name',
                displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.NAME'
            },
            {
                field: 'email',
                displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.EMAIL',
                width: '40%'
            },
            {
                field: 'mobile',
                displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.MOBILE',
                cellFilter: 'local_phone_number: mobile',
                enableSorting: false,
                enableColumnMenu: false
            },
            {  // ACTION BUTTON COLUMN
                field: 'action',
                displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                enableFiltering: false,
                headerCellClass: 'action-column-header',
                enableSorting: false,
                enableColumnMenu: false,
                width: '10%',
                cellTemplate: 'clients/action.html'
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
