'use strict'

###*
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeStates
*
* @description
* Returns an instance of $stateProvider that allows late state binding (on runtime)
###

###*
* @ngdoc service
* @name BBAdminDashboard.services.service:RuntimeStatesProvider
*
* @description
* Provider
*
* @example
  <pre>
  angular.module('ExampleModule').config ['RuntimeStatesProvider', '$stateProvider', (RuntimeStatesProvider, $stateProvider) ->
    RuntimeStatesProvider.setProvider($stateProvider)
  ]
  </pre>
###
angular.module('BBAdminDashboard.services').provider 'RuntimeStates', ['$stateProvider', ($stateProvider)->
  stateProvider  = $stateProvider
  @setProvider = (provider)->
    stateProvider = provider
  @$get = ->
    stateProvider
  return
]
