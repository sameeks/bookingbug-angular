(function (angular) {

    /*
     * @ngdoc controller
     * @name BBAdminDashboard.login.controllers.controller:LoginPageCtrl
     *
     * @description
     * Controller for the login page
     */
    angular.module('BBAdminDashboard.login.controllers').controller('LoginPageCtrl', LoginPageCtrl);

    function LoginPageCtrl($scope, $state, AdminCoreOptions, user) {
        'ngInject';

        $scope.user = user;

        $scope.loginSuccess = function (company) {
            $scope.company = company;
            $scope.bb.company = company;
            $state.go(AdminCoreOptions.default_state);
        };
    }

})(angular);
