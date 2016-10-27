'use strict'

angular.module('BBAdminDashboard').config ($logProvider, $httpProvider) ->
  'ngInject'

  $logProvider.debugEnabled(true)
  $httpProvider.defaults.withCredentials = true

  return