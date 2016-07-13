'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.publish-iframe.translations
#
* @description
* Translations for the admin publish-iframe module
###
angular.module('BBAdminDashboard.publish-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]
