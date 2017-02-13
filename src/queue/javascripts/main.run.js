'use strict'

angular.module('BBQueue').run () ->
  'ngInject'

  models = ['Queuer', 'ClientQueue']
  for model in models
    BBModel['Admin'][model] = $injector.get("Admin#{model}Model")
  BBModel['Admin']['Person'] = $injector.get("AdminQueuerPersonModel")

  return