'use strict'

adminbookingapp = angular.module('BBAdminDashboard', [
  'trNgGrid',
  'BBAdmin',
  'BBAdmin.Services',
  'ui.calendar',
  'ngStorage',
  'BBAdminBooking',
])

angular.module('BBAdminDashboard').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdminDashboard.Directives', [])

angular.module('BBAdminDashboard.Services', [
  'ngResource',
  'ngSanitize'
  'ngLocalData'
])

angular.module('BBAdminDashboard.Controllers', [
  'ngLocalData',
  'ngSanitize'
])
