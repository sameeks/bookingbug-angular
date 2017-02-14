// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * @ngdoc overview
 * @name BBAdminDashboard.clients.translations
 *
 * @description
 * Translations for the admin clients module
 */
angular.module('BBAdminDashboard.clients.translations')
    .config(['$translateProvider', $translateProvider =>
        $translateProvider.translations('en', {
            'ADMIN_DASHBOARD': {
                'SIDE_NAV': {
                    'CLIENTS_PAGE': {
                        'CLIENTS': 'Customers'
                    }
                },
                'CLIENTS_PAGE': {
                    'CLIENTS': 'Customers',
                    'CLIENT': 'Customer',
                    'NAME': 'Name',
                    'EMAIL': 'Email',
                    'MOBILE': 'Mobile',
                    'PHONE': 'Phone',
                    'ACTIONS': 'Actions',
                    'EDIT': 'Edit',
                    'ABOUT': 'About',
                    'ADDRESS': 'Address',
                    'UPCOMING_BOOKINGS': 'Upcoming Bookings',
                    'PAST_BOOKINGS': 'Past Bookings',
                    'CUSTOMER_DETAILS': 'Customer Details'
                }
            }
        })

    ]);
