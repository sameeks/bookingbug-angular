###
* @ngdoc service
* @module BB.Services
* @name GeneralOptions
*
* @description
* Returns a set of General configuration options
###

###
* @ngdoc service
* @module BB.Services
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
angular.module('BB.Services').provider 'AdminBookingOptions', [ ->
  # This list of default options is meant to grow
  options = {
    merge_resources: true
    merge_people: true
  }

  @setOption = (option, value) ->
    if options.hasOwnProperty(option)
      options[option] = value
    return

  @$get =  ->
    options

  return
]