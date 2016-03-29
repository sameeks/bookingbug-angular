'use strict'

angular.module('BBAdmin', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Controllers',
  'BBAdmin.Models',
  'BBAdmin.Directives',
  'trNgGrid'
  # 'ui.state',
#  'ui.calendar',
])

angular.module('BBAdmin').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdmin.Directives', [])

angular.module('BBAdmin.Filters', [])

angular.module('BBAdmin.Models', [])

angular.module('BBAdmin.Services', [
  'ngResource',
  'ngSanitize',
  'ngLocalData'
])

angular.module('BBAdmin.Controllers', [
  'ngLocalData',
  'ngSanitize'
])

angular.module('BBAdmin.Services').run ($q, $injector, BBModel) ->
  models = ['Booking', 'Slot', 'User', 'Administrator', 'Schedule', 'Address',
    'Resource', 'Person', 'Service', 'Login', 'EventChain', 'EventGroup', 'Event', 'Queuer', 'ClientQueue', 'Clinic']

  afuncs = {}
  for model in models
    afuncs[model] = $injector.get("Admin." + model + "Model")
  BBModel['Admin'] = afuncs

angular.module('BBAdmin').run ($rootScope, $log, DebugUtilsService, FormDataStoreService, $bbug, $document, $injector, $sessionStorage, AppConfig, BBModel) ->
  # add methods to the rootscope if they are applicable to whole app
  BBModel.Admin.Login.$checkLogin().then () ->
    if $rootScope.user && $rootScope.user.company_id
      $rootScope.bb ||= {}
      $rootScope.bb.company_id = $rootScope.user.company_id
