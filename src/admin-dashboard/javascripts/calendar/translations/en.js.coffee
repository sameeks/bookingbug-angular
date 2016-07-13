'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.calendar.translations
#
* @description
* Translations for the admin calendar module
###
angular.module('BBAdminDashboard.calendar.translations')
.config ['$translateProvider', ($translateProvider)->
	$translateProvider.translations('en',{
    'SIDE_NAV': {
      'CALENDAR_PAGE': {
        'CALENDAR' : 'Calendar'
      }
    },
    'CALENDAR_PAGE': {
    	'SHOW'	 								  : 'Show',
    	'ALL' 										: 'all',
    	'SOME'										: 'some',
    	'SELECT_STAFF_RESOURECES' : 'Select staff or resource...'
    	'EMAIL'                   : 'email',
    	'TODAY'                   : 'Today'
    	'WEEK'                    : 'Week',
    	'MONTH'										: 'Month',
    	'DAY'											: 'Day ({{minutes}}m)',
    	'STAFF'										: 'Staff',
    	'RESOURCES'							  : 'Resources',
    }
  })
]