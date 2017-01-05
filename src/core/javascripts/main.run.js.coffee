'use strict'

angular.module('BB').run ($bbug, DebugUtilsService, FormDataStoreService, $log, $rootScope, $sessionStorage, GeneralOptions) ->
  'ngInject'

  $rootScope.$log = $log
  $rootScope.$setIfUndefined = FormDataStoreService.setIfUndefined

  $rootScope.bb ||= {}
  $rootScope.bb.api_url = $sessionStorage.getItem("host")

  if ($bbug.support.opacity == false)
    document.createElement('header')
    document.createElement('nav')
    document.createElement('section')
    document.createElement('footer')

  if GeneralOptions.set_time_zone_automatically
    GeneralOptions.display_time_zone = moment.tz.guess()

  if localStorage.selectedTimeZone
    GeneralOptions.display_time_zone = localStorage.selectedTimeZone

  return
