'use strict'

angular.module('BBAdmin', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Filters',
  'BBAdmin.Directives',
  'BBAdmin.Controllers',
  'BBAdmin.Models',
  'BBAdmin.Directives',
  'trNgGrid'
])

angular.module('BBAdmin').config ($logProvider) ->
  $logProvider.debugEnabled(true)

angular.module('BBAdmin.Directives', [])

angular.module('BBAdmin.Filters', [])

angular.module('BBAdmin.Models', [])

angular.module('BBAdmin.Services', [
  'ngResource',
  'ngSanitize',
])

angular.module('BBAdmin.Controllers', [
  'ngSanitize'
])

angular.module('BBAdmin.Services').run ($q, $injector, BBModel) ->
  models = ['Booking', 'Slot', 'User', 'Administrator', 'Schedule', 'Address',
    'Resource', 'Person', 'Service', 'Login', 'EventChain', 'EventGroup',
    'Event', 'Clinic', 'Company', 'Client']

  afuncs = {}
  for model in models
    afuncs[model] = $injector.get("Admin" + model + "Model")
  BBModel['Admin'] = afuncs


angular.module('BB').config (FormTransformProvider) ->
  FormTransformProvider.setTransform 'edit', 'Admin_Booking', (form) ->
    if form[0].tabs
      _.each form[0].tabs[0].items, (item) ->
        if _.indexOf(['datetime', 'service', 'person_id', 'current_multi_status'], item.key) > -1
          item.readonly = true
    else
      _.each form, (item) ->
        if _.indexOf(['datetime', 'service', 'person_id'], item.key) > -1
          item.readonly = true
    form

