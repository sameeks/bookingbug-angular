'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.translations
#
* @description
* Translations for the admin core module
###
angular.module('BBAdminDashboard.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en',{
    'SIDE_NAV_BOOKINGS' : 'BOOKINGS',
    'SIDE_NAV_CONFIG'   : 'CONFIGURATION',
    'LANGUAGE_EN'       : 'English',
    'GREETING'          : 'Hi',
    'LOGOUT'            : 'Logout'
    'VERSION'           : 'Version',
    'COPYRIGHT'         : 'Copyright'
    'SWITCH_TO_CLASSIC' : 'Switch to Classic'
  })
]