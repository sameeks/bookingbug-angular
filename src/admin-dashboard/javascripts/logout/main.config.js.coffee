'use strict'

angular.module('BBAdminDashboard.logout').config ($stateProvider) ->
  'ngInject'

  $stateProvider
  .state 'logout',
    url: '/logout'
    controller: 'LogoutPageCtrl'

  return
