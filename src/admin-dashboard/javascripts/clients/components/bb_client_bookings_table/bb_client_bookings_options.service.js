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
angular.module('BBAdminDashboard.clients.services').provider('ClientBookingsTableOptions', function (bbOptionsProvider) {
    let options = {
        basicOptions: {
            disableScrollBars: true,
            enableRowSelection: true,
            enableFullRowSelection: true,
            enableRowHeaderSelection: false,
            enableColumnMenus: false,
            enableSorting: true,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 50
        },
        displayOptions: [
            { field: 'datetime', displayName: 'Data/Time', cellFilter: 'datetime: "ddd DD MMM YY h.mma"', width: '45%'},
            { field: 'details', displayName: 'Description', width: '45%'},
            {  // DETAILS BUTTON COLUMN
                field: 'detailsCell',
                width: '10%',
                cellClass: 'action-cell',
                displayName: 'ADMIN_DASHBOARD.CLIENTS_PAGE.ACTIONS',
                cellTemplate: 'bookings_table_action_button.html'
            }
        ]

    };

    this.setOption = function (option, value) {
        options = bbOptionsProvider.setOption(options, option, value);
    };

    this.getOption = function (option) {
        return options[option];
    };
    this.$get = () => options;

});
