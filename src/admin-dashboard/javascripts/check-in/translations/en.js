/*
* @ngdoc overview
* @name BBAdminDashboard.check-in.translations
*
* @description
* Translations for the admin check-in module
*/
angular.module('BBAdminDashboard.check-in.translations')
.config(['$translateProvider', $translateProvider=>
  $translateProvider.translations('en', {

    'ADMIN_DASHBOARD': {

      'SIDE_NAV': {
        'CHECK_IN_PAGE': {
          'CHECK_IN': 'Check in'
        }
      },

      'CHECK_IN_PAGE': {
        'CHECK_IN'        : 'Check in',
        'NO_SHOW'         : 'No Show',
        'WALK_IN'         : 'Walk in',
        'CUSTOMER'        : 'Customer',
        'STAFF_MEMBER'    : 'Staff Member',
        'DUE'             : 'Due',
        'ARRIVED'         : 'Arrived',
        'BEEING_SEEN'     : 'Being Seen',
        'COMPLETED'       : 'Completed',
        'NO_SHOW_BUTTON'  : 'Mark No Show',
        'CHECK_IN_BUTTON' : 'Check in',
        'SERVE'           : 'Serve',
        'WAITING_FOR'     : 'Waiting for {{period}}',
        'BEING_SEEN_FOR'  : 'Being seen for {{period}}',
        'WAS_DUE'         : 'Was due {{period}}',
        'COMPLETED_BUTTON': 'Completed'
      }

    }

  })

]);