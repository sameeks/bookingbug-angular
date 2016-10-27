'use strict'

angular.module('BBAdmin.Services').run ($q, $injector, BBModel) ->
  'ngInject'

  models = ['Booking', 'Slot', 'User', 'Administrator', 'Schedule', 'Address',
    'Resource', 'Person', 'Service', 'Login', 'EventChain', 'EventGroup',
    'Event', 'Clinic', 'Company', 'Client']

  afuncs = {}
  for model in models
    afuncs[model] = $injector.get("Admin" + model + "Model")
  BBModel['Admin'] = afuncs

  return
