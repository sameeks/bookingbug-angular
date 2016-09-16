'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.settings-iframe.translations
#
* @description
* Translations for the admin settings-iframe module
###
angular.module('BBAdminDashboard.settings-iframe.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en', {
    'ADMIN_DASHBOARD': {
      'SIDE_NAV'            : {
        'SETTINGS_IFRAME_PAGE': {
          'ACCOUNT_SETTINGS' : 'Account settings',
          'MY_BUSINESS'      : 'My business',
          'BASIC_SETTINGS'   : 'Basic settings',
          'ADVANCED_SETTINGS': 'Advanced settings',
          'INTEGRATIONS'     : 'Integrations',
          'IMAGES'           : 'Images',
          'USERS_ADMINS'     : 'Users &amp; Admins',
          'ANNOUNCEMENTS'    : 'Announcements',
          'SUBSCRIPTION'     : 'Subscription'
        }
      },
      'SETTINGS_IFRAME_PAGE': {
        'BASIC_SETTINGS'   : {
          'TITLE'             : 'Settings',
          'TAB_BUSINESS'      : 'Business',
          'TAB_SERVICES'      : 'Services',
          'TAB_STAFF'         : 'Staff',
          'TAB_EVENTS'        : 'Events',
          'TAB_RESOURCES'     : 'Resources',
          'TAB_WIDGET'        : 'Widget',
          'TAB_BOOKINGS'      : 'Bookings',
          'TAB_NOTIFICATIONS' : 'Notifications',
          'TAB_PRICING'       : 'Pricing',
          'TAB_TERMINOLOGY'   : 'Terminology',
          'TAB_CUSTOM_TCS'    : 'Custom T&amp;Cs',
          'TAB_EXTRA_FEATURES': 'Extra features'
        },
        'ADVANCED_SETTINGS': {
          'TITLE'                      : 'Advanced settings',
          'TAB_ONLINE_PAYMENTS'        : 'Online payments',
          'TAB_ACCOUNTING_INTEGRATIONS': 'Accounting Integrations',
          'TAB_BUSINESS_QUESTIONS'     : 'Business Questions',
          'TAB_API_SETTINGS'           : 'API settings'
        },
        'INTEGRATIONS'     : {
          'TITLE'         : 'Integrations',
          'TAB_PAYMENT'   : 'Payment',
          'TAB_ACCOUNTING': 'Accounting',
          'TAB_OTHER'     : 'Other'
        },
        'SUBSCRIPTION'     : {
          'TITLE'              : 'Subscription',
          'TAB_STATUS'         : 'Status',
          'TAB_PAYMENT_HISTORY': 'Payment history',
          'TAB_INVOICES'       : 'Invoices'
        }
      }
    }
  })
]