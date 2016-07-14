'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.calendar.translations
#
* @description
* Translations for the admin calendar module
###
angular.module('BBAdminDashboard.calendar.translations')
.config ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_2': 'Hello there!',
  })

