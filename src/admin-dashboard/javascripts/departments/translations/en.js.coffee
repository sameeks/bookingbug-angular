'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.departments.translations
#
* @description
* Translations for the admin departments module
###
angular.module('BBAdminDashboard.departments.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'TEXT_1': 'Hello here!',
  })
]