'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.clients.translations
#
* @description
* Translations for the admin clients module
###
angular.module('BBAdminDashboard.clients.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]
