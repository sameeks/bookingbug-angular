'use strict'

queueapp = angular.module('BBQueue', [
  'BB',
  'BBAdmin.Services',
  'BBAdmin.Directives',
  'BBQueue.Services',
  'BBQueue.Directives',
  'BBQueue.Controllers',
  'trNgGrid',
  'ngDragDrop',
  'pusher-angular'
])

angular.module('BBQueue.Directives', [
  'timer'
])

angular.module('BBQueue.Controllers', [])

angular.module('BBQueue.Services', [
  'ngResource',
  'ngSanitize'
])

angular.module('BBQueueMockE2E', ['BBQueue', 'BBAdminMockE2E'])

angular.module('BBQueue.Services').run () ->
  models = ['Queuer', 'ClientQueue']
  for model in models
    BBModel['Admin'][model] = $injector.get("Admin.#{model}Model")

