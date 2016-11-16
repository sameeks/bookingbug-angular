'use strict'

###
 * @ngdoc directive
 * @name BBAdminDashboard.reset-password.directive:adminDashboardResetPassword
 * @scope
 * @restrict A
 *
 * @description
 * Admin Dashboard ResetPassword journey directive
###

adminDashboardResetPassword = () ->

  directive =
    restrict: 'AE'
    replace: true
    scope : true
    template: '<div ng-include="$resetPasswordCtrl.reset_password_template"></div>'
    controller: 'ResetPasswordCtrl'
    controllerAs: '$resetPasswordCtrl'

  return directive

angular
  .module('BBAdminDashboard.reset-password')
  .directive('adminDashboardResetPassword', adminDashboardResetPassword)
