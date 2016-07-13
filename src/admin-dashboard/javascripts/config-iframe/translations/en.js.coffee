'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.config-iframe.translations
#
* @description
* Translations for the admin config-iframe module
###
angular.module('BBAdminDashboard.config-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]
