(function () {

     /*
     * @ngdoc service
     * @name BBAdminDashboard.clients.services.service:ClientBookingsTableOptions
     *
     * @description
     * Returns a set of client booking grid configuration options
     */

    angular
        .module('BBAdminDashboard.clients.services')
        .provider('ClientBookingsTableOptions', ClientBookingsTableOptions);


    function ClientBookingsTableOptions(bbOptionsProvider) {
        let options = {
            paginationPageSize: 15,
            disableScrollBars: true,
            basicOptions: {
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
                    cellTemplate: 'clients/action.html'
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

    }
})();
