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
    ADMIN_DASHBOARD: {
      CORE: {
        GREETING         : 'Hi',
        LOGOUT           : 'Logout'
        VERSION          : 'Version',
        COPYRIGHT        : 'Copyright',
        SWITCH_TO_CLASSIC: 'Switch to Classic'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return

