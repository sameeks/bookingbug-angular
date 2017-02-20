angular.module('BBAdmin.Controllers').controller('TimeOptions', function ($scope, $location, $rootScope, BBModel) {

    BBModel.Admin.Resource.$query({company: $scope.bb.company}).then(resources => $scope.resources = resources);

    BBModel.Admin.Person.$query({company: $scope.bb.company}).then(people => $scope.people = people);

    return $scope.block = function () {
        if ($scope.person) {
            let params = {
                start_time: $scope.start_time,
                end_time: $scope.end_time
            };
            BBModel.Admin.Person.$block($scope.bb.company, $scope.person, params);
        }
        return $scope.ok();
    };
});

