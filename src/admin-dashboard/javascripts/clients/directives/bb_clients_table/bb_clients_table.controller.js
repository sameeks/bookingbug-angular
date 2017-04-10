angular
    .module('BBAdminDashboard.clients.directives')
    .controller('TabletClients', bbTabletClients);

function bbTabletClients($scope, $rootScope, $q, BBModel, AlertService, uiGridConstants) {
    $scope.clientDef = $q.defer();
    $scope.clientPromise = $scope.clientDef.promise;
    let perPage = 15;
    $scope.total_entries = 0;
    $scope.clients = [];

    return $scope.getClients = function (pageNumber, searchFields) {
        let clientDef = $q.defer();

        let params = {
            company: $scope.company,
            per_page: perPage,
            page: $scope.paginationOptions.pageNumber,
            // filter_by: $scope.clientsOptions.search,
            filter_by_fields: searchFields
        };

        return BBModel.Admin.Client.$query(params).then(clients => {
                $scope.gridOptions.totalItems = clients.total_entries;
                $scope.clients = clients.items;

                let firstRow = ($scope.paginationOptions.pageNumber - 1) * $scope.paginationOptions.pageSize;
                $scope.gridOptions.data = $scope.clients.slice(firstRow, firstRow + $scope.paginationOptions.pageSize);

                $scope.gridOptions.data = $scope.clients;
                return clientDef.resolve(clients.items);
            }
            , function (err) {
                console.log(err);
                return clientDef.reject(err);
            });
    };
}


