###
* @ngdoc service
* @module BBAdminBooking
* @name GeneralOptions
*
* @description
* Returns a set of General configuration options
###

###
* @ngdoc service
* @module BBAdminBooking
* @name GeneralOptionsProvider
*
* @description
* Provider 
*
* @example
  <example>
  angular.module('ExampleModule').config ['GeneralOptionsProvider', (GeneralOptionsProvider) ->
    GeneralOptionsProvider.setOption('twelve_hour_format', true)
  ]
  </example>
###
angular.module('BBAdminBooking').provider 'GeneralOptions', [ ->
  # This list of default options is meant to grow
  options = {
    twelve_hour_format : false,
    calendar_minute_step: 10
  }

  @setOption = (option, value) ->
    if options.hasOwnProperty(option)
      options[option] = value
    return

  @$get =  ->
    options

  return
]