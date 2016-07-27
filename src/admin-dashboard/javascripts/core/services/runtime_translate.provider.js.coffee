'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeTranslate
*
* @description
* Returns an instance of $translateProvider that allows late language binding (on runtime)
###

###
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeTranslateProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['RuntimeTranslateProvider', '$translateProvider', (RuntimeTranslateProvider, $translateProvider) ->
    RuntimeTranslateProvider.setProvider($translateProvider)
  ]
  </example>
###
angular.module('BBAdminDashboard.services').provider 'RuntimeTranslate', ['$translateProvider', ($translateProvider)->
  translateProvider  = $translateProvider
  @setProvider = (provider)->
    translateProvider = provider
  @$get = ->
    translateProvider
  return
]