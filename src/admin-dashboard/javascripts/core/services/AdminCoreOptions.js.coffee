'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.services.service:AdminCoreOptions
*
* @description
* Returns a set of General configuration options
###

###
* @ngdoc service
* @name BBAdminDashboard.services.service:AdminCoreOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminCoreOptionsProvider', (AdminCoreOptionsProvider) ->
    AdminCoreOptionsProvider.setOption('option', 'value')
  ]
  </example>
###
angular.module('BBAdminDashboard.services').provider 'AdminCoreOptions', [ ->
  # This list of options is meant to grow
  options = {
   
  }

  @setOption = (option, value) ->
    if options.hasOwnProperty(option)
      options[option] = value
    return

  @getOption = (option) ->
    if options.hasOwnProperty(option)
      return options[option]
    return
  @$get =  ->
    options

  return
]