'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.members-iframe.translations
#
* @description
* Translations for the admin members module
###
angular.module('BBAdminDashboard.members-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]