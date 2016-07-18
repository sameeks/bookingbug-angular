'use strict'

###
* @ngdoc service
* @module BB.Services
* @name AdminBookingOptions
*
* @description
* Returns a set of Admin Booking configuration options
###

###
* @ngdoc service
* @module BB.Services
* @name AdminBookingOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminBookingOptionsProvider', (AdminBookingOptionsProvider) ->
    GeneralOptionsProvider.setOption('twelve_hour_format', true)
  ]
  </example>
###
angular.module('BB.Services').provider 'AdminBookingOptions', ->
  # This list of default options is meant to grow
  options = {
    merge_resources: true
    merge_people: true
    day_view: 'multi_day'
  }

  @setOption = (option, value) ->
    if options.hasOwnProperty(option)
      options[option] = value
    return

  @$get =  ->
    options

  return

