'use strict';

###*
* @ngdoc overview
* @name BBAdminDashboard.translations
* @description
* Translations for the admin core module
###

angular.module('BBAdminDashboard').config ($translateProvider) ->
  'ngInject'

  translations = {
    SIDE_NAV_BOOKINGS: "BOOKINGS"
    SIDE_NAV_CONFIG: "CONFIGURATION"
    ADMIN_DASHBOARD: {
      CORE: {
        GREETING         : 'Hi'
        LOGOUT           : 'Logout'
        VERSION          : 'Version'
        COPYRIGHT        : 'Copyright'
        SWITCH_TO_CLASSIC: 'Switch to Classic'
        PREFERENCES: {
          SET_TIMEZONE_LABEL: 'Set timezone automatically'
          SET_TIMEZONE_ON_LABEL: 'On'
          SET_TIMEZONE_OFF_LABEL: 'Off'
          TIMEZONE_LABEL: 'Timezone'
        }
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
