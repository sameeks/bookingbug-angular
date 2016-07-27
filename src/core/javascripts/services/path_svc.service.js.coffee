'use strict'

service = ($sce, AppConfig) ->
  'ngInject'

  ###
  @param {String} fileName
  @returns {Object}
  ###
  directivePartial = (fileName) ->
    if AppConfig.partial_url
      partialUrl = AppConfig.partial_url
      return $sce.trustAsResourceUrl("#{partialUrl}/#{fileName}.html")
    else
      return $sce.trustAsResourceUrl("#{fileName}.html")

  return {
    directivePartial: directivePartial
  }

angular.module('BB.Services').service 'PathSvc', service
