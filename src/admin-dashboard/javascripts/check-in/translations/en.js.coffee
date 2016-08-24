'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.check-in.translations
#
* @description
* Translations for the admin check-in module
###
angular.module('BBAdminDashboard.check-in.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en',{
    'SIDE_NAV': {
      'CHECK_IN_PAGE': {
        'CHECK_IN' : 'Check in'
      }
    }
    'CHECK_IN_PAGE': {
      'CHECK_IN'              : 'Check in',
      'WALK_IN'               : 'Walk in',
      'CUSTOMER'              : 'Customer',
      'STAFF_MEMBER'          : 'Staff Member',
      'DUE'                   : 'Due',
      'ARRIVED'               : 'Arrived',
      'BEEING_SEEN'           : 'Being Seen',
      'COMPLETED'             : 'Completed',
      'CHECK_IN_BUTTON'       : 'Check in',
      'CHECK_IN_PAGE.WAS_DUE' : 'Was due at',
      'SERVE'                 : 'Serve',
      'WAITING_FOR'           : 'Waiting for {{period}}',
      'BEING_SEEN_FOR'        :  'Being seen for {{period}}',
      'WAS_DUE'               : 'Was due {{period}}',
      'COMPLETED_BUTTON'      : 'Completed'
    }
  })
]