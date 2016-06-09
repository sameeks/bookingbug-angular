'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.settings-iframe.translations
#
* @description
* Translations for the admin settings-iframe module
###
angular.module('BBAdminDashboard.settings-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]