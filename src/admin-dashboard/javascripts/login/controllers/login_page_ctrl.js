(function (angular) {

    /*
     * @ngdoc controller
     * @name BBAdminDashboard.login.controllers.controller:LoginPageCtrl
     *
     * @description
     * Controller for the login page
     */
    angular.module('BBAdminDashboard.login.controllers').controller('LoginPageCtrl', LoginPageCtrl);

    function LoginPageCtrl($scope, $state, AdminCoreOptions, user, $rootScope) {
        'ngInject';

        $scope.user = user; // Notice: might be undefined if user not loggedIn with SSO

        $scope.loginSuccess = function (company) {
            $scope.company = company;
            $scope.bb.company = company;

            redirectUser();
        };

        const redirectUser = () => {
            if ($rootScope.user.role === 'callcenter') {
                $state.go('callCenter'); //TODO config options ?
                return;
            }
            $state.go(AdminCoreOptions.default_state);
        }
    }

})(angular);
