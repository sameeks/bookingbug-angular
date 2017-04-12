angular
    .module('BBAdminDashboard.clients.directives')
    .controller('TabletClients', bbTabletClients);

function bbTabletClients($scope, $rootScope, $q, BBModel) {
    $scope.clients = [];
    let perPage = 15;

    $scope.getClients = (pageNumber, searchFields) => {
        let clientDef = $q.defer();

        let params = {
            company: $scope.company,
            per_page: perPage,
            page: $scope.paginationOptions.pageNumber,
            filter_by_fields: searchFields
            // filter_by: $scope.clientsOptions.search
        };

        return BBModel.Admin.Client.$query(params).then(clients => {
                $scope.gridOptions.totalItems = clients.total_entries;
                $scope.clients = clients.items;

                let firstRow = ($scope.paginationOptions.pageNumber - 1) * $scope.paginationOptions.pageSize;
                $scope.gridOptions.data = $scope.clients.slice(firstRow, firstRow + $scope.paginationOptions.pageSize);

                $scope.gridOptions.data = $scope.clients;
                return clientDef.resolve(clients.items);
            }
            , (err) => {
                console.log('Error getting clients', err);
                return clientDef.reject(err);
            }
        );
    };
}


