angular.module('BBAdminServices').directive('resourceTable', function (BBModel, $log,
                                                                       ModalForm) {

    let controller = function ($scope) {

        $scope.fields = ['id', 'name'];

        $scope.getResources = function () {
            let params =
                {company: $scope.company};
            return BBModel.Admin.Resource.$query(params).then(resources => $scope.resources = resources);
        };

        $scope.newResource = () =>
            ModalForm.new({
                company: $scope.company,
                title: 'New Resource',
                new_rel: 'new_resource',
                post_rel: 'resources',
                size: 'lg',
                success(resource) {
                    return $scope.resources.push(resource);
                }
            })
        ;

        $scope.delete = resource =>
            resource.$del('self').then(() => $scope.resources = _.reject($scope.resources, p => p.id === id)
                , err => $log.error("Failed to delete resource"))
        ;

        $scope.edit = resource =>
            ModalForm.edit({
                model: resource,
                title: 'Edit Resource'
            })
        ;

        return $scope.schedule = resource =>
            resource.$get('schedule').then(schedule =>
                ModalForm.edit({
                    model: schedule,
                    title: 'Edit Schedule'
                })
            )
            ;
    };

    let link = function (scope, element, attrs) {
        if (scope.company) {
            return scope.getResources();
        } else {
            return BBModel.Admin.Company.$query(attrs).then(function (company) {
                scope.company = company;
                return scope.getResources();
            });
        }
    };

    return {
        controller,
        link,
        templateUrl: 'resource_table_main.html'
    };
});

