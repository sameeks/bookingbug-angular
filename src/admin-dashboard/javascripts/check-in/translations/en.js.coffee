'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.check-in.translations
#
* @description
* Translations for the admin check-in module
###
angular.module('BBAdminDashboard.check-in.translations')
.config ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })

