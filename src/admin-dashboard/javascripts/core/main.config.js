angular.module('BBAdminDashboard').config(function ($logProvider, $httpProvider) {
    'ngInject';

    $logProvider.debugEnabled(true);
    $httpProvider.defaults.withCredentials = true;

});
