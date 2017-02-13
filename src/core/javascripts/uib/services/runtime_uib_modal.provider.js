'use strict'

###*
* @ngdoc service
* @name BB.uib.runtimeUibModal
*
* @description
* Returns an instance of $uibModalProvider that allows to set modal default options (on runtime)
###
angular.module('BB.uib').provider 'runtimeUibModal', ($uibModalProvider)->
  'ngInject'

  uibModalProvider = $uibModalProvider
  @setProvider = (provider)->
    uibModalProvider = provider
  @$get = ->
    uibModalProvider
  return
