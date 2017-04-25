/*
* @ngdoc overview
* @name BBQueue.translations
*
* @description
* Translations for the queue people module
*/
angular.module('BBQueue.translations')
.config(['$translateProvider', $translateProvider=>
    $translateProvider.translations('en', {
        'SIDE_NAV_QUEUING': 'QUEUING',
        'ADMIN_DASHBOARD': {
            'SIDE_NAV': {
                'QUEUE_PAGE': {
                    'QUEUE': 'Concierge',
                    'REPORT': 'Queue Reports',
                    'BOOKING_REPORT': 'Booking Reports',
                    'PERF_REPORT': 'Performance Reports',
                    'MAP_REPORT': 'Map Reports',
                    'LIST': 'Queue Display'
                }
            },
            'QUEUE_PAGE': {
                'PEOPLE': 'Colleagues',
                'PERSON': 'Colleague',
                'DATETIME': 'Date Time',
                'DETAILS': 'Details',
                'CLIENT': 'Client',
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
                'NEXT_BOOKING_DIALOG_HEADING': 'Upcoming Appointment',
                'NEXT_BOOKING_DIALOG_BODY': '{{name}} has an appointment at {{time}}. Are you sure they want to serve another customer beforehand?'
            }
        }
    })

]);
