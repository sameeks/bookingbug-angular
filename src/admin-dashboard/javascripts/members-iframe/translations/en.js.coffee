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
    'SIDE_NAV': {
      'MEMBERS_IFRAME_PAGE': {
        'MEMBERS'           	: 'Members',
        'ALL_CLIENTS'    			: 'All clients',
        'QUESTIONS'    				: 'Questions',
        'EXPORT_TO_MAILCHIMP' : 'Export to Mailchimp'
      }
    },
  })
]