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
  $translateProvider.translations('en', {

    'ADMIN_DASHBOARD': {

      'SIDE_NAV': {
        'CALENDAR_PAGE': {
          'CALENDAR': 'Calendar'
          'PEOPLE': 'Staff'
          'RESOURCES': 'Resources'
        }
      },

      'CALENDAR_PAGE': {
        'SHOW'                  : 'Show',
        'ALL'                   : 'all',
        'SOME'                  : 'some',
        'SELECT_STAFF_RESOURCES': 'Select staff or resource...'
        'EMAIL'                 : 'email',
        'TODAY'                 : 'Today'
        'WEEK'                  : 'Week',
        'MONTH'                 : 'Month',
        'DAY'                   : 'Day ({{minutes}}m)',
        'AGENDA'                : 'Agenda',
        'STAFF'                 : 'Staff',
        'RESOURCES'             : 'Resources',
        'MOVE_MODAL_TITLE'      : 'Move',
        'MOVE_MODAL_BODY'       : 'Are you sure you want to move?',
        'ADD_BOOKING'           : 'Add Booking',
      }
    }
  })
]
