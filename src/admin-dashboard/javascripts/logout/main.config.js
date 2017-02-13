angular.module('BBAdminDashboard.logout').config(function($stateProvider, $urlRouterProvider) {
  'ngInject';

  $stateProvider
  .state('logout', {
    url: '/logout',
    controller: 'LogoutPageCtrl'
  }
  );

});