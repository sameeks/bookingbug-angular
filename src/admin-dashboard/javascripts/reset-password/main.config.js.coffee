'use strict'

angular.module('BBAdminDashboard.reset-password').config ($stateProvider, $urlRouterProvider) ->
  'ngInject'

  $stateProvider
  .state 'reset-password',
    url: '/reset-password'
    controller: 'ResetPasswordPageCtrl'
    templateUrl: "reset-password/index.html"

  return
