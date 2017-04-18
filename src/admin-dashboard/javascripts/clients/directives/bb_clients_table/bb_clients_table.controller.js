(() => {

    angular
        .module('BBAdminDashboard.clients.controllers')
        .controller('bbClientsTableCtrl', bbClientsTable);

    function bbClientsTable($scope, $rootScope, $q, BBModel) {
        let clientData = [];
        let per_page = 15;

        /***
         * @ngdoc method
         * @name getClients
         * @methodOf BBAdminDashboard.clients.directives:bbClientsTable
         * @description
         * Gets the current dates appointments to be displayed in the check in table
         *
         * @param {integer} pageNumber The pagination page number of the clients to get
         * @param {string} filter_by_fields The string of fields and values to search by. e.g "name,v,email,o"
        */
        $scope.getClients = (pageNumber, filter_by_fields) => {
            let clientDef = $q.defer();

            let params = {
                company: $scope.company,
                page: pageNumber,
                filter_by_fields,
                per_page
                // filter_by: $scope.clientsOptions.search
            };

            return BBModel.Admin.Client.$query(params).then(clients => {
                    $scope.gridOptions.totalItems = clients.total_entries;
                    clientData = clients.items;

                    let firstRow = ($scope.paginationOptions.pageNumber - 1) * $scope.paginationOptions.pageSize;
                    $scope.gridOptions.data = clientData.slice(firstRow, firstRow + $scope.paginationOptions.pageSize);

                    $scope.gridOptions.data = clientData;
                    return clientDef.resolve(clients.items);
                }
                , (err) => {
                    console.log('Error getting clients', err);
                    return clientDef.reject(err);
                }
            );
        };
    }

})();


