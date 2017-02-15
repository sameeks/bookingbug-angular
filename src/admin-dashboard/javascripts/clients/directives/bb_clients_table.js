// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.clients.directives').directive('bbClientsTable', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'TabletClients',
            link(scope, element, attrs) {

            }
        };
    }
);


angular.module('BBAdminDashboard.clients.directives').controller('TabletClients', function ($scope, $rootScope, $q, BBModel, AlertService) {

    $scope.clientDef = $q.defer();
    $scope.clientPromise = $scope.clientDef.promise;
    $scope.per_page = 15;
    $scope.total_entries = 0;
    $scope.clients = [];

    return $scope.getClients = function (currentPage, filterBy, filterByFields, orderBy, orderByReverse) {
        let fields = angular.copy(filterByFields);
        //   if fields.name?
        //    fields.name = fields.name.replace(/\s/g, '')
        if (fields.mobile != null) {
            let {mobile} = fields;
            if (mobile.indexOf('0') === 0) {
                fields.mobile = mobile.substring(1);
            }
        }

        let clientDef = $q.defer();

        let params = {
            company: $scope.bb.company,
            per_page: $scope.per_page,
            page: currentPage + 1,
            filter_by: filterBy,
            filter_by_fields: fields,
            order_by: orderBy,
            order_by_reverse: orderByReverse
        };
        return BBModel.Admin.Client.$query(params).then(clients => {
                $scope.clients = clients.items;
                $scope.total_entries = clients.total_entries;
                return clientDef.resolve(clients.items);
            }
            , function (err) {
                console.log(err);
                return clientDef.reject(err);
            });
    };
});

