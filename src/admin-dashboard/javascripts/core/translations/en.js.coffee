'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.translations
#
* @description
* Translations for the admin core module
###
angular.module('BBAdminDashboard.translations')
.config ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })

