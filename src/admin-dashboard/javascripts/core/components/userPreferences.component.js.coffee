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

  this.preventClose = (event) ->
    event.stopPropagation()

  return

userPreferencesComponent =
  templateUrl: 'core/_user-preferences.html',
  controller: userPreferencesController

angular
  .module 'BBAdminDashboard'
  .component 'userPreferences', userPreferencesComponent
