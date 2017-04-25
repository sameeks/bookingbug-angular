angular.module('BBAdmin.Directives').directive('bbAdminClients', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'AdminClients',
            link(scope, element, attrs) {
            }
        };
    }
);


angular.module('BBAdmin.Controllers').controller('AdminClients', function ($scope, $rootScope, $q, $log, AlertService, LoadingService, BBModel) {

    $scope.clientDef = $q.defer();
    $scope.clientPromise = $scope.clientDef.promise;
    $scope.per_page = 15;
    $scope.total_entries = 0;
    $scope.clients = [];

    let loader = LoadingService.$loader($scope);

    $scope.getClients = function (currentPage, filterBy, filterByFields, orderBy, orderByReverse) {
        let clientDef = $q.defer();

        $rootScope.connection_started.then(function () {
            loader.notLoaded();
            let params = {
                company: $scope.bb.company,
                per_page: $scope.per_page,
                page: currentPage + 1,
                filter_by: filterBy,
                filter_by_fields: filterByFields,
                order_by: orderBy,
                order_by_reverse: orderByReverse
            };
            return BBModel.Admin.Client.$query(params).then(clients => {
                    $scope.clients = clients.items;
                    loader.setLoaded();
                    $scope.setPageLoaded();
                    $scope.total_entries = clients.total_entries;
                    return clientDef.resolve(clients.items);
                }
                , function (err) {
                    clientDef.reject(err);
                    return loader.setLoadedAndShowError(err, 'Sorry, something went wrong');
                });
        });
        return true;
    };

    return $scope.edit = item => $log.info("not implemented");
});

