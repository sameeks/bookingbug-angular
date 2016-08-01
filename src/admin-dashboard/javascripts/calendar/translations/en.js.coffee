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
  console.log "load1"
  $translateProvider.translations('en',{
    'SIDE_NAV': {
      'CALENDAR_PAGE': {
        'CALENDAR' : 'Calendar'
      }
    },
    'CALENDAR_PAGE': {
      'SHOW'                    : 'Show',
      'ALL'                     : 'all',
      'SOME'                    : 'some',
      'SELECT_STAFF_RESOURCES'  : 'Select staff or resource...'
      'EMAIL'                   : 'email',
      'TODAY'                   : 'Today'
      'WEEK'                    : 'Week',
      'MONTH'                   : 'Month',
      'DAY'                     : 'Day ({{minutes}}m)',
      'STAFF'                   : 'Staff',
      'RESOURCES'               : 'Resources',
      'MOVE_MODAL_TITLE'        : 'Move',
      'MOVE_MODAL_BODY'         : 'Are you sure you want to move this booking?',
    }
  })
]