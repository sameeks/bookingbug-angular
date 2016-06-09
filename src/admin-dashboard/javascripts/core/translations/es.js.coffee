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
  $translateProvider.translations('es',{
    'SIDE_NAV_BOOKINGS': 'BOOKINGS ES',
    'SIDE_NAV_CONFIG': 'CONFIGURATION ES',
    'LANGUAGE_EN': 'Anglais',
    'LANGUAGE_ES': 'Espaniol'
  })
]