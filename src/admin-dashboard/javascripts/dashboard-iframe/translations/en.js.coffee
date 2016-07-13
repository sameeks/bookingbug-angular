'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.dashboard-iframe.translations
#
* @description
* Translations for the admin dashboard-iframe module
###
angular.module('BBAdminDashboard.dashboard-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]
