'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.calendar.services.service:AdminCalendarOptions
*
* @description
* Returns a set of admin calendar configuration options
###

###
* @ngdoc service
* @name BBAdminDashboard.calendar.services.service:AdminCalendarOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminCalendarOptionsProvider', (AdminCalendarOptionsProvider) ->
    AdminCalendarOptionsProvider.setOption('option', 'value')
  ]
  </example>
###
angular.module('BBAdminDashboard.calendar.services').provider 'AdminCalendarOptions', [ ->
  # This list of options is meant to grow
  options = {
    useDefaultStates         : true
    showInNavigation         : true
    parentState              : 'root'
    columnFormat             : null
    bookingsLabelAssembler   : '{service_name} - {client_name}'
    blockLevelAssembler      : 'Blocked'
    externalLabelAssembler   : '{title}'
    minTime                  : null
    maxTime                  : null
    slotDuration             : 15
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