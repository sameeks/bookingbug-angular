'use strict'

###
* @ngdoc overview
* @name BBAdminDashboard.login.translations
#
* @description
* Translations for the admin login module
###
angular.module('BBAdminDashboard.login.translations')
.config ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })

