'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.services.service:TemplateService
*
* @description
* Checks if a custom version of the requested template exists in the templateCache,
* otherwise returns the default version (which should be compiled with the module)
###
angular.module('BBAdminDashboard.services').factory 'TemplateService', (
  $templateCache, $exceptionHandler) ->

    {
      get: (template)->
        if $templateCache.get(template)?
          return $templateCache.get(template)
        else if $templateCache.get('/default' + template)?
          return $templateCache.get('/default' + template)
        else
          $exceptionHandler(new Error('Template "' + template + '" not found'), '', true)
    }

