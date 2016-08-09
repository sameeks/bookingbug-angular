'use strict';


###
* @ngdoc overview
* @name BBAdminDashboard.bookings.translations
#
* @description
* Translations for the admin bookings module
###
angular.module('BBAdminDashboard.bookings.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en',{
    'SIDE_NAV': {
      'BOOKINGS_PAGE': {
        'BOOKINGS' : 'Bookings'
      }
    }
    'BOOKINGS_PAGE': {
      'BOOKINGS'           : 'Bookings',
      'BOOKING'            : 'Booking',
      'NAME'              : 'Name',
      'EMAIL'             : 'Email',
      'MOBILE'            : 'Mobile',
      'PHONE'             : 'Phone',
      'ACTIONS'           : 'Actions',
      'EDIT'              : 'Edit',
      'ABOUT'             : 'About',
      'ADDRESS'           : 'Address',
      'UPCOMING_BOOKINGS' : 'Upcoming Bookings',
      'PAST_BOOKINGS'     : 'Past Bookings'
    }
  })
]