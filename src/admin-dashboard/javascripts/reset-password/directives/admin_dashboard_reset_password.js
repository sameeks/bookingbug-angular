/*
 * @ngdoc directive
 * @name BBAdminDashboard.reset-password.directive:adminDashboardResetPassword
 * @scope
 * @restrict A
 *
 * @description
 * Admin Dashboard ResetPassword journey directive
*/

let adminDashboardResetPassword = function() {

  let directive = {
    restrict: 'AE',
    replace: true,
    scope : true,
    template: '<div ng-include="$resetPasswordCtrl.resetPasswordTemplate"></div>',
    controller: 'ResetPasswordCtrl',
    controllerAs: '$resetPasswordCtrl'
  };

  return directive;
};

angular
  .module('BBAdminDashboard.reset-password')
  .directive('adminDashboardResetPassword', adminDashboardResetPassword);
