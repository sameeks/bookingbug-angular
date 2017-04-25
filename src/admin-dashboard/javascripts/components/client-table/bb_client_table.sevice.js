(function () {

    /**
     * @ngdoc service
     * @name BBAdminDashboard.ClientTableService
     *
     * @description
     * Responsible for getting company customer data
     *
    */

    angular
        .module('BBAdminDashboard')
        .factory('ClientTableService', ClientTableService);

    function ClientTableService($q, BBModel, $rootScope) {
        return {

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
            getClients(paginationOptions, filter_by_fields) {
                let clientDef = $q.defer();

                const params = {
                    company: $rootScope.bb.company,
                    page: paginationOptions.pageNumber,
                    per_page: paginationOptions.pageSize,
                    filter_by_fields
                    // filter_by: $scope.clientsOptions.search
                };

                BBModel.Admin.Client.$query(params).then(clients => {
                    const firstRow = (paginationOptions.pageNumber - 1) * paginationOptions.pageSize;
                    const gridData = clients.items.slice(firstRow, firstRow + paginationOptions.pageSize);

                    return clientDef.resolve(gridData);
                }
                , (err) => {
                    console.log('Error getting clients', err);
                    return clientDef.reject(err);

                });
            }
        };
    }
})();

