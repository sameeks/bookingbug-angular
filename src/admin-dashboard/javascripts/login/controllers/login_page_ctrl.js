/*
* @ngdoc controller
* @name BBAdminDashboard.login.controllers.controller:LoginPageCtrl
*
* @description
* Controller for the login page
*/
angular.module('BBAdminDashboard.login.controllers')
.controller('LoginPageCtrl',['$scope', '$state', 'AdminLoginService', 'AdminCoreOptions','user', function($scope, $state, AdminLoginService, AdminCoreOptions, user) {
  $scope.user = user;

  return $scope.loginSuccess = function(company) {
    $scope.company = company;
    $scope.bb.company = company;
    return $state.go(AdminCoreOptions.default_state);
  };
}
]);