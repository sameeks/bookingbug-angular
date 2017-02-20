/*
 * @ngdoc controller
 * @name BBAdminDashboard.reset-password.controller:ResetPasswordPageCtrl
 *
 * @description
 * Controller for the reset password page
 */

let ResetPasswordPageCtrl = function ($scope) {
    'ngInject';

    let init = function () {

        if (($scope.bb.api_url != null) && ($scope.bb.api_url !== '')) {
            $scope.baseUrl = angular.copy($scope.bb.api_url);
        }

    };

    init();

};

angular
    .module('BBAdminDashboard.reset-password')
    .controller('ResetPasswordPageCtrl', ResetPasswordPageCtrl);
