'use strict'

adminapp = angular.module('BBAdmin', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Controllers',
  'trNgGrid'
  # 'ui.state',
#  'ui.calendar',
])

angular.module('BBAdmin').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdmin.Directives', [])

angular.module('BBAdmin.Filters', [])

angular.module('BBAdmin.Services', [
  'ngResource',
  'ngSanitize',
  'ngLocalData'
])

angular.module('BBAdmin.Controllers', [
  'ngLocalData',
  'ngSanitize'
])

angular.module('BBAdmin.Models', []).service 'BBModel' , ($q, $injector) ->

adminapp.run ($rootScope, $log, DebugUtilsService, FormDataStoreService, $bbug, $document, $injector, $sessionStorage, AppConfig, AdminLoginService, BBModel) ->
  models = ['Booking', 'Slot', 'User', 'Administrator', 'Schedule', 'Address',
    'Resource', 'Person', 'Service', 'Login', 'EventChain', 'EventGroup', 'Event', 'Queuer', 'ClientQueue', 'Clinic']

  afuncs = {}
  for model in models
    afuncs[model] = $injector.get("Admin." + model + "Model")
  BBModel['Admin'] = afuncs
  # add methods to the rootscope if they are applicable to whole app
  AdminLoginService.checkLogin().then () ->
    if $rootScope.user && $rootScope.user.company_id
      $rootScope.bb ||= {}
      $rootScope.bb.company_id = $rootScope.user.company_id
