// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminDashboard.logout').config(function ($stateProvider, $urlRouterProvider) {
    'ngInject';

    $stateProvider
        .state('logout', {
                url: '/logout',
                controller: 'LogoutPageCtrl'
            }
        );

});
