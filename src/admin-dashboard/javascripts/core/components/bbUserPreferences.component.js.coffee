'use strict'

###**
* @ngdoc component
* @name BBAdminDashboard.userPreferences
*
* @description
* Preferences component in Admin user dropdown
*
* @example
* <example>
*   <user-preferences></user-preferences>
* </example>
###

userPreferencesController = () ->

  @preventClose = (event) ->
    event.stopPropagation()

  return

userPreferencesComponent =
  templateUrl: 'core/_bb-user-preferences.html',
  controller: userPreferencesController

angular
  .module 'BBAdminDashboard'
  .component 'bbUserPreferences', userPreferencesComponent
