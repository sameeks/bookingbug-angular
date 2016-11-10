'use strict'

angular.module('BBAdminDashboard.reset-password').config ($stateProvider, $urlRouterProvider) ->
  'ngInject'

  $stateProvider
  .state 'reset-password',
    url: '/reset-password'
    controller: 'resetPasswordPageCtrl'
    templateUrl: "reset-password/index.html"

  return