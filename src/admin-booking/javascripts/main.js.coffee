'use strict'

adminbookingapp = angular.module('BBAdminBooking', [
  'BB'
  'BBAdmin.Services'
  'BBAdminServices'
  'trNgGrid'
])

angular.module('BBAdminBooking').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdminBooking.Directives', [])

angular.module('BBAdminBooking.Services', [
  'ngResource'
  'ngSanitize'
])

angular.module('BBAdminBooking.Controllers', [
  'ngLocalData'
  'ngSanitize'
])

adminbookingapp.run ($rootScope, $log, DebugUtilsService, $bbug, $document,
  $sessionStorage, FormDataStoreService, AppConfig, BBModel) ->

  BBModel.Admin.Login.$checkLogin().then () ->
    if $rootScope.user && $rootScope.user.company_id
      $rootScope.bb ||= {}
      $rootScope.bb.company_id = $rootScope.user.company_id

