'use strict'

angular.module('BB.uib').run ($document, runtimeUibModal) ->
  'ngInject'

  init = () ->
    setUibModalDefaults()
    return

  setUibModalDefaults = () ->
    runtimeUibModal.options.appendTo = angular.element($document[0].getElementById('bb'))
    return

  init()
  return
