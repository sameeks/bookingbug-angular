angular.module('BBAdmin.Controllers').controller('CategoryList', function ($scope,
                                                                           $location, $rootScope, BBModel) {

    $rootScope.connection_started.then(() => {
            $scope.categories = BBModel.Category.$query($scope.bb.company);

            return $scope.categories.then(items => {
            });
        }
    );

    $scope.$watch('selectedCategory', (newValue, oldValue) => {

            $rootScope.category = newValue;

            return $('.inline_time').each((idx, e) => angular.element(e).scope().clear());
        }
    );

    return $scope.$on("Refresh_Cat", (event, message) => {
            return $scope.$apply();
        }
    );
});

