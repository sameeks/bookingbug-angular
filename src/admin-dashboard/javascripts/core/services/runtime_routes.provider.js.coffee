'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeRoutes
*
* @description
* Returns an instance of $routeProvider that allows late route binding (on runtime)
###

###*
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeRoutesProvider
*
* @description
* Provider
*
* @example
  <pre>
  angular.module('ExampleModule').config ['RuntimeRoutesProvider', '$routeProvider', (RuntimeRoutesProvider, $routeProvider) ->
    RuntimeRoutesProvider.setProvider($routeProvider)
  ]
  </pre>
###
angular.module('BBAdminDashboard.services').provider 'RuntimeRoutes', ['$urlRouterProvider', ($urlRouterProvider)->
  routeProvider  = $urlRouterProvider
  @setProvider = (provider)->
    routeProvider = provider
  @$get = ->
    routeProvider
  return
]
