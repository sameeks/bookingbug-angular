angular.module('BBAdmin.Controllers').controller('CompanyList', function ($scope,
                                                                          $rootScope, $location) {

    let d, date, result;
    $scope.selectedCategory = null;

    $rootScope.connection_started.then(() => {
            date = moment();
            $scope.current_date = date;
            $scope.companies = $scope.bb.company.companies;
            if (!$scope.companies || ($scope.companies.length === 0)) {
                $scope.companies = [$scope.bb.company];
            }
            $scope.dates = [];
            let end = moment(date).add(21, 'days');
            $scope.end_date = end;
            d = moment(date);
            return (() => {
                result = [];
                while (d.isBefore(end)) {
                    $scope.dates.push(d.clone());
                    result.push(d.add(1, 'days'));
                }
                return result;
            })();
        }
    );

    $scope.selectCompany = item => $location = `/view/dashboard/pick_company/${item.id}`;

    $scope.advance_date = function (num) {
        date = $scope.current_date.add(num, 'days');
        $scope.end_date = moment(date).add(21, 'days');
        $scope.current_date = moment(date);
        $scope.dates = [];
        d = date.clone();
        return (() => {
            result = [];
            while (d.isBefore($scope.end_date)) {
                $scope.dates.push(d.clone());
                result.push(d.add(1, 'days'));
            }
            return result;
        })();
    };

    return $scope.$on("Refresh_Comp", (event, message) => $scope.$apply());
});

