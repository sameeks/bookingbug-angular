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
    'TEXT_2': 'Hello ombre!',
  })
]