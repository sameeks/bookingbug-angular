'use strict'

angular.module('BBAdminDashboard.logout').config ($stateProvider, $urlRouterProvider) ->
  'ngInject'

  $stateProvider
  .state 'logout',
    url: '/logout'
    controller: 'LogoutPageCtrl'

  return