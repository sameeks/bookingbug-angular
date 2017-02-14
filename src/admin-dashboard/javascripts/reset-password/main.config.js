// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.reset-password').config(function ($stateProvider, $urlRouterProvider) {
    'ngInject';

    $stateProvider
        .state('reset-password', {
                url: '/reset-password',
                controller: 'ResetPasswordPageCtrl',
                templateUrl: "reset-password/index.html"
            }
        );

});
