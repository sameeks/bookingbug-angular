'use strict'

###
* @ngdoc service
* @name BBAdminDashboard.departments.services.service:AdminDepartmentsOptions
*
* @description
* Returns a set of admin calendar configuration options
###

###
* @ngdoc service
* @name BBAdminDashboard.departments.services.service:AdminDepartmentsOptionsProvider
*
* @description
* Provider
*
* @example
  <example>
  angular.module('ExampleModule').config ['AdminDepartmentsOptionsProvider', (AdminDepartmentsOptionsProvider) ->
    AdminDepartmentsOptionsProvider.setOption('option', 'value')
  ]
  </example>
###
angular.module('BBAdminDashboard.departments.services').provider 'AdminDepartmentsOptions', [ ->
  # This list of options is meant to grow
  options = {
    use_default_states : true
    show_in_navigation : true
    parent_state       : 'bb-admin'
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