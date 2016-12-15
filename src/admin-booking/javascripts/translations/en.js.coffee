'use strict';

angular.module('BBAdminBooking').config ($translateProvider) ->
  'ngInject'

  translations = {
    ADMIN_BOOKING: {
      CALENDAR: {
        STEP_HEADING                       : 'Select a time'
        TIME_NOT_AVAILABLE_STEP_HEADING    : 'Time not available'
        ANY_PERSON_OPTION                  : 'Any person'
        ANY_RESOURCE_OPTION                : 'Any resource'
        BACK_BTN                           : '@:COMMON.BTN.BACK'
        SELECT_BTN                         : '@:COMMON.BTN.SELECT'
        CALENDAR_PANEL_HEADING             : '@:COMMON.TERMINOLOGY.CALENDAR'
        NOT_AVAILABLE                      : 'Time not available: {{time | datetime: "lll"}}'
        CONFLICT_EXISTS                    : 'There\'s an availability conflict'
        CONFLICT_EXISTS_WITH_PERSON        : 'with {{ person_name }}'
        CONFLICT_EXISTS_IN_RESOURCE        : 'in {{ resource_name }}'
        CONFLICT_RESULT_OF                 : 'This can be the result of:'
        CONFLICT_REASON_ALREADY_BOOKED     : 'The Staff/Resource being booked or blocked already'
        CONFLICT_REASON_NOT_ENOUGH_TIME    : 'Not enough available time to complete the booking before an existing one starts'
        CONFLICT_REASON_OUTSIDE            : 'The selected time being outside of the {{booking_time_step | time_period}} booking time step for {{service_name}}.'
        CONFLICT_ANOTHER_TIME_OR_OVERBOOK  : 'You can either use the calendar to choose another time or overbook.'
        DAY_VIEW_BTN                       : 'Day'
        DAY_3_VIEW_BTN                     : '3 day'
        DAY_5_VIEW_BTN                     : '5 day'
        DAY_7_VIEW_BTN                     : '7 day'
        FIRST_FOUND_VIEW_BTN               : 'First available'
        TIME_SLOT_WITH_COUNTDOWN           : '{{datetime | "LT"}} (in {{time | tod_from_now}})'
        NOT_FOUND                          : 'No availability found'
        NOT_FOUND_TRY_DIFFERENT_TIME_RANGE : 'No availability found, try a different time-range'
        OVERBOOK_WARNING                   : 'Overbooking ignores booking time step and availability constraints to make a booking.'
        FILTER_BY_LABEL                    : 'Filter by'

        SELECT_A_TIME_FOR_BOOKING          : 'Select a time for the booking.'
        OVERLAPPING_BOOKINGS               : 'The following bookings look like they are clashing with this requested time'
        NEARBY_BOOKINGS                    : 'The following nearby bookings might be clashing with this requested time'
        EXTERNAL_BOOKINGS                  : 'The following external calendar bookings look like they are clashing with this requested time'

        EXTERNAL_BOOKING_DESCRIPTION       : "{{title}} from {{from | datetime: 'lll'}} to {{to | datetime: 'lll'}}"
        ALTERNATIVE_TIME_NO_OVERBOOKING    : 'It looks like the booking step that service was configured for doesn\'t allow that time. You can select an alternative time, or you can try booking the requested time anyway, however making double bookings is not allowed by your business configuration settings'
        ALTERNATIVE_TIME_ALLOW_OVERBOOKING : 'The following external calendar bookings look like they are clashing with this requested time'

        CLOSEST_TIME_NO_OVERBOOKING        : 'Looks like that time wasn\'t available. This could just be because it would outside of their normal schedule. This was the closest time I found. You can select an alternative time, or you can try booking the requested time anyway, however double bookings aren\'t allowed by your company configuration settings'
        CLOSEST_TIME_ALLOW_OVERBOOKING     : 'Looks like that time wasn\'t available. This could just be because it would outside of their normal schedule. This was the closest time I found. You can select an alternative time, or you can try booking the requested time anyway'

        CLOSEST_EARLIER_TIME_BTN           : 'Closest Earlier: {{closest_earlier | datetime: "LT"}}'
        CLOSEST_LATER_TIME_BTN             : 'Closest Later: {{cloest_later | datetime: "LT"}}'
        REQUESTED_TIME_BTN                 : 'Requested Time: {{requested_time: datetime: "LT"}}'
        FIND_ANOTHER_TIME_BTN              : 'Find another time'
        MORNING_HEADER                     : '@:COMMON.TERMINOLOGY.MORNING'
        AFTERNOON_HEADER                   : '@:COMMON.TERMINOLOGY.AFTERNOON'
        EVENING_HEADER                     : '@:COMMON.TERMINOLOGY.EVENING'
      }
      CUSTOMER: {
        BACK_BTN                : '@:COMMON.BTN.BACK'
        CLEAR_BTN               : '@:COMMON.BTN.CLEAR'
        CREATE_HEADING          : 'Create Customer'
        CREATE_BTN              : 'Create Customer'
        CREATE_ONE_INSTEAD_BTN  : 'Create one instead'
        EMAIL                   : '@:COMMON.FORM.EMAIL'
        FIRST_NAME              : '@:COMMON.FORM.FIRST_NAME'
        LAST_NAME               : '@:COMMON.FORM.LAST_NAME'
        MOBILE                  : '@:COMMON.FORM.MOBILE:'
        NO_RESULTS_FOUND        : 'No results found'
        NUM_CUSTOMERS           : '{CUSTOMERS_NUMBER, plural, =0{no customers} =1{one customer} other{{CUSTOMERS_NUMBER} customers}} found'
        SEARCH_BY_PLACEHOLDER   : 'Search by email or name'
        STEP_HEADING            : 'Select a customer'
        SELECT_BTN              : '@:COMMON.BTN.SELECT'
        SORT_BY_LABEL           : 'Sort by'
        SORT_BY_EMAIL           : '@:COMMON.FORM.EMAIL'
        SORT_BY_FIRST_NAME      : '@:COMMON.FORM.FIRST_NAME'
        SORT_BY_LAST_NAME       : '@:COMMON.FORM.LAST_NAME'
        ADDRESS1_LABEL          : '@:COMMON.FORM.ADDRESS1'
        ADDRESS1_VALIDATION_MSG : 'Please enter an address'
        ADDRESS3_LABEL          : '@:COMMON.FORM.ADDRESS3'
        ADDRESS4_LABEL          : '@:COMMON.FORM.ADDRESS4'
        POSTCODE_LABEL          : '@:COMMON.FORM.POSTCODE'
      }
      QUICK_PICK: {
        BLOCK_WHOLE_DAY                : 'Block whole day'
        BLOCK_TIME_TAB_HEADING         : 'Block time'
        FOR_LABEL                      : 'For'
        FROM_LABEL                     : 'From'
        MAKE_BOOKING_TAB_HEADING       : 'Make booking'
        NO_OPTION                      : '@:COMMON.BTN.NO'
        RESOURCE_DEFAULT_OPTION        : '-- select --'
        TO_LABEL                       : 'To'
        YES_OPTION                     : '@:COMMON.BTN.YES'
        RESOURCE_PERSON_VALIDATION_MSG : 'Please select a resource or member of staff'
        STEP_SUMMARY                   : 'Select a service'
        SELECT_BTN                     : '@:COMMON.BTN.SELECT'
        FIELD_REQUIRED                 : '@:COMMON.FORM.FIELD_REQUIRED'
        BLOCK_TIME_BTN                 : "Block time"
      }
      BOOKINGS_TABLE : {
        CANCEL_BTN  : '@:COMMON.BTN.CANCEL'
        DETAILS_BTN : '@:COMMON.BTN.DETAILS'
      }
      ADMIN_MOVE_BOOKING : {
        CANCEL_CONFIRMATION_HEADING : "Your booking has been cancelled."
        HEADING                     : "Your {{service_name}} booking"
        CUSTOMER_NAME_LABEL         : "Name"
        PRINT_BTN                   : "@:COMMON.TERMINOLOGY.PRINT"
        EMAIL_LABEL                 : "@:COMMON.FORM.EMAIL"
        SERVICE_LABEL               : "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL                  : "@:COMMON.TERMINOLOGY.WHEN"
        PRICE_LABEL                 : "@:COMMON.TERMINOLOGY.PRICE"
        CANCEL_BOOKING_BTN          : "@:COMMON.BTN.CANCEL_BOOKING"
        MOVE_BOOKING_BTN            : "Move booking"
        BOOK_WAITLIST_ITEMS_BTN     : "Book Waitlist Items"
      }
      CHECK_ITEMS: {
        BOOKINGS_QUESTIONS_HEADING    : "Booking Questions"
        PRIVATE_BOOKING_NOTES_HEADING : "Private Notes"
        BOOK_BTN                      : "@:COMMON.BTN.BOOK"
        BACK_BTN                      : "@:COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        TITLE                 : "Confirmation"
        BOOKING_CONFIRMATION  : "Booking is now confirmed."
        EMAIL_CONFIRMATION    : "An email has been sent to {{customer_name}} with the details below."
        WAITLIST_CONFIRMATION : "You have successfully made the following bookings."
        PRINT_BTN             : "@:COMMON.TERMINOLOGY.PRINT"
        PURCHASE_REF_LABEL    : "Reference:"
        CUSTOMER_LABEL        : "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LABEL         : "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_TIME_LABEL       : "Date/Time"
        TIME_LABEL            : "@:COMMON.TERMINOLOGY.TIME"
        PRICE_LABEL           : "@:COMMON.TERMINOLOGY.PRICE"
        CLOSE_BTN             : "Close"
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
