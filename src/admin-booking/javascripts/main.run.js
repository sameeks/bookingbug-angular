'use strict'

angular.module('BBAdminBooking').run ($rootScope, $log, DebugUtilsService, $bbug, $document,
  $sessionStorage, FormDataStoreService, AppConfig, BBModel) ->
  'ngInject'

  BBModel.Admin.Login.$checkLogin().then () ->
    if $rootScope.user && $rootScope.user.company_id
      $rootScope.bb ||= {}
      $rootScope.bb.company_id = $rootScope.user.company_id

  return