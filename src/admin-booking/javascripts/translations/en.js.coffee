'use strict';

angular.module('BBAdminBooking').config ($translateProvider) ->
  'ngInject'

  translations = {
    ADMIN_BOOKING: {
      AVAILABILITY: {
        ANY_PERSON                        : 'Any person'
        ANY_RESOURCE                      : 'Any resource'
        BACK                              : 'Back'
        BOOK                              : 'Book'
        CALENDAR                          : 'Calendar'
        NOT_AVAILABLE                     : 'Time not available'
        CONFLICT_EXISTS                   : 'There\'s an availability conflict'
        CONFLICT_EXISTS_WITH_PERSON       : 'with {{ person_name }}'
        CONFLICT_EXISTS_IN_RESOURCE       : 'in {{ resource_name }}'
        CONFLICT_RESULT_OF                : 'This can be the result of:'
        CONFLICT_REASON_ALREADY_BOOKED    : 'The Staff/Resource being booked or blocked already'
        CONFLICT_REASON_NOT_ENOUGH_TIME   : 'Not enough available time to complete the booking before an existing one starts'
        CONFLICT_REASON_OUTSIDE           : 'The selected time being outside of the {{booking_time_step | time_period}} booking time step for {{service_name}}.'
        CONFLICT_ANOTHER_TIME_OR_OVERBOOK : 'You can either use the calendar to choose another time or overbook.'
        DAY                               : 'Day'
        DAY_3                             : '3 day'
        DAY_5                             : '5 day'
        DAY_7                             : '7 day'
        FIRST_FOUND                       : 'First available'
        NOT_FOUND                         : 'No availability found'
        NOT_FOUND_TRY_DIFFERENT_TIME_RANGE: 'No availability found, try a different time-range'
        OVERBOOK                          : 'Overbook'
        OVERBOOK_BTN                      : 'Overbook'
        OVERBOOK_WARNING                  : 'Overbooking ignores booking time step and availability constraints to make a booking.'
        FILTER_BY                         : 'Filter by:'
        SELECT_A_TIME                     : 'Select a time'
        SELECT_A_TIME_FOR_BOOKING         : 'Select a time for the booking.'
      }
      CALENDAR    : {
        AFTERNOON: 'Afternoon'
        EVENING  : 'Evening'
        MORNING  : 'Morning'
      }
      CUSTOMER    : {
        BACK_BTN          : 'Back'
        CLEAR             : 'Clear'
        CREATE            : 'Create Customer'
        CREATE_BTN        : 'Create Customer'
        CREATE_ONE_INSTEAD: 'Create one instead'
        EMAIL             : 'Email:'
        FIRST_NAME        : 'First name:'
        LAST_NAME         : 'Last name:'
        MOBILE            : 'Mobile:'
        NO_RESULTS_FOUND  : 'No results found'
        NUMBER            : '{CUSTOMERS_NUMBER, plural, =0{no customers} =1{one customer} other{{CUSTOMERS_NUMBER} customers}} found'
        SEARCH_BY         : 'Search by email or name'
        SELECT_HEADLINE   : 'Select a customer'
        SELECT_BTN        : 'Select'
        SORT_BY           : 'Sort by:'
        SORT_BY_EMAIL     : 'Email'
        SORT_BY_FIRST_NAME: 'First Name'
        SORT_BY_LAST_NAME : 'Last Name'
        ADDRESS1_LABEL    : 'Address'
        ADDRESS1_VALIDATION_MSG : 'Please enter your address'
        ADDRESS3_LABEL   : 'Town'
        ADDRESS4_LABEL   : 'County'
        POSTCODE_LABEL   : 'Postcode'

      }
      QUICK_PICK  : {
        BLOCK_WHOLE_DAY      : 'Block whole day'
        BLOCK_TIME           : 'Block time'
        BOOK                 : 'Book'
        FOR                  : 'For'
        FROM                 : 'From'
        MAKE_BOOKING         : 'Make booking'
        NO                   : 'No'
        SELECT               : '-- select --'
        SELECT_A_SERVICE     : '-- select a service --'
        SERVICE              : 'Service'
        TO                   : 'To'
        YES                  : 'Yes'
        FIELD_VALIDATION_MSG : 'This field is required'
        RESOURCE_PERSON_VALIDATION_MSG : 'Please select a resource or member of staff'
      }
      BOOKINGS_TABLE : {
        CANCEL_BTN  : 'Cancel'
        DETAILS_BTN : 'Details'
      }
      CHECK_ITEMS : {
        BOOKINGS_QUESTIONS_TITLE : 'Questions'
        FIELD_VALIDATION_MSG     : 'This field is required'
        BOOKING_NOTES_TITLE      : 'Booking Notes'
        BOOK_BTN                 : 'Book'
        BACK_BTN                 : ''

      }

    }
  }

  $translateProvider.translations('en', translations)

  return
