(function (angular) {
    /**
     * @ngdoc directive
     * @name BBAdminDashboard.directive:bbChildCompanySwitch
     * @scope
     * @restrict A
     * @description
     * Functionality that allows you to switch between child companies
     */
    angular.module('BBAdminDashboard').directive('bbChildCompanySwitch', () => {
        return {
            restrict: 'A',
            replace: true,
            scope: true,
            controller: BBChildCompanySwitchCtrl
        };
    });

    function BBChildCompanySwitchCtrl(AdminLoginService, $scope, $state) {
        'ngInject';

        const parentCompanyFetchedListener = (parentCompany) => {
            AdminLoginService
                .setCompany(parentCompany.id)
                .then(
                    parentCompanySetListener,
                    () => $scope.formErrors.push({message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"})
                );
        };

        const parentCompanySetListener = () => {
            $state.go('login');
        };

        return $scope.logoutChildCompany = () => {
            $scope.bb.company.$getParent().then(
                parentCompanyFetchedListener,
                () => $scope.formErrors.push({message: "ADMIN_DASHBOARD.LOGIN_PAGE.ERROR_ISSUE_WITH_COMPANY"})
            );
        };
    }

})(angular);
