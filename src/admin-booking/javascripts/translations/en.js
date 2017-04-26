angular.module("BBAdminBooking").config(function ($translateProvider) {
    "ngInject";

    let translations = {
        ADMIN_BOOKING: {
            ASSETS: {
                RESOURCES_GROUP_LABEL: "@:COMMON.TERMINOLOGY.RESOURCES",
                STAFF_GROUP_LABEL: "@:COMMON.TERMINOLOGY.STAFF"
            },
            CALENDAR: {
                STEP_HEADING: "Select a time",
                TIME_NOT_AVAILABLE_STEP_HEADING: "Time not available",
                ANY_PERSON_OPTION: "Any person",
                ANY_RESOURCE_OPTION: "Any resource",
                BACK_BTN: "@:COMMON.BTN.BACK",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                CALENDAR_PANEL_HEADING: "@:COMMON.TERMINOLOGY.CALENDAR",
                NOT_AVAILABLE: "Time not available: {{time | datetime: 'lll':true}}",
                CONFLICT_EXISTS: "There\'s an availability conflict",
                CONFLICT_EXISTS_WITH_PERSON: "with {{person_name}}",
                CONFLICT_EXISTS_IN_RESOURCE: "in {{resource_name}}",
                CONFLICT_RESULT_OF: "This can be the result of:",
                CONFLICT_REASON_ALREADY_BOOKED: "The Staff/Resource being booked or blocked already",
                CONFLICT_REASON_NOT_ENOUGH_TIME: "Not enough available time to complete the booking before an existing one starts",
                CONFLICT_REASON_OUTSIDE: "The selected time being outside of the {{booking_time_step | time_period}} booking time step for {{service_name}}.",
                CONFLICT_ANOTHER_TIME_OR_OVERBOOK: "You can either use the calendar to choose another time or overbook.",
                DAY_VIEW_BTN: "Day",
                DAY_3_VIEW_BTN: "3 day",
                DAY_5_VIEW_BTN: "5 day",
                DAY_7_VIEW_BTN: "7 day",
                FIRST_FOUND_VIEW_BTN: "First available",
                TIME_SLOT_WITH_COUNTDOWN: "{{datetime | datetime:'LT':true}} (in {{time | tod_from_now}})",
                NOT_FOUND: "No availability found",
                NOT_FOUND_TRY_DIFFERENT_TIME_RANGE: "No availability found, try a different time-range",
                OVERBOOK_WARNING: "Overbooking ignores booking time step and availability constraints to make a booking.",
                FILTER_BY_LBL: "Filter by",

                SELECT_A_TIME_FOR_BOOKING: "Select a time for the booking.",
                OVERLAPPING_BOOKINGS: "The following bookings look like they are clashing with this requested time",
                NEARBY_BOOKINGS: "The following nearby bookings might be clashing with this requested time",
                EXTERNAL_BOOKINGS: "The following external calendar bookings look like they are clashing with this requested time",

                EXTERNAL_BOOKING_DESCRIPTION: "{{title}} from {{from | datetime: 'lll':true}} to {{to | datetime: 'lll':true}}",
                ALTERNATIVE_TIME_NO_OVERBOOKING: "It looks like the booking step that service was configured for doesn't allow that time. You can select an alternative time, or you can try booking the requested time anyway, however making double bookings is not allowed by your business configuration settings",
                ALTERNATIVE_TIME_ALLOW_OVERBOOKING: "The following external calendar bookings look like they are clashing with this requested time",

                CLOSEST_TIME_NO_OVERBOOKING: "Looks like that time wasn\'t available. This could just be because it would be outside of their normal schedule. This was the closest time I found. You can select an alternative time, or you can try booking the requested time anyway, however double bookings aren\'t allowed by your company configuration settings",
                CLOSEST_TIME_ALLOW_OVERBOOKING: "Looks like that time wasn\'t available. This could just be because it would be outside of their normal schedule. This was the closest time I found. You can select an alternative time, or you can try booking the requested time anyway",

                CLOSEST_EARLIER_TIME_BTN: "Closest Earlier: {{closest_earlier | datetime: 'LT':true}}",
                CLOSEST_LATER_TIME_BTN: "Closest Later: {{closest_later | datetime: 'LT':true}}",
                REQUESTED_TIME_BTN: "Requested Time: {{requested_time | datetime: 'LT':true}}",
                FIND_ANOTHER_TIME_BTN: "Find another time",
                MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING",
                AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON",
                EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
            },
            CUSTOMER: {
                BACK_BTN: "@:COMMON.BTN.BACK",
                CLEAR_BTN: "@:COMMON.BTN.CLEAR",
                CREATE_HEADING: "Create Customer",
                CREATE_BTN: "Create Customer",
                CREATE_ONE_INSTEAD_BTN: "Create one instead",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME",
                LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME",
                MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE",
                NO_RESULTS_FOUND: "No results found",
                NUM_CUSTOMERS: "{CUSTOMERS_NUMBER, plural, =0{no customers} =1{one customer} other{{CUSTOMERS_NUMBER} customers}} found",
                SEARCH_BY_PLACEHOLDER: "Search by email or name",
                STEP_HEADING: "Select a customer",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                SORT_BY_LBL: "Sort by",
                SORT_BY_EMAIL: "@:COMMON.TERMINOLOGY.EMAIL",
                SORT_BY_FIRST_NAME: "@:COMMON.TERMINOLOGY.FIRST_NAME",
                SORT_BY_LAST_NAME: "@:COMMON.TERMINOLOGY.LAST_NAME",
                ADDRESS1_LBL: "@:COMMON.TERMINOLOGY.ADDRESS1",
                ADDRESS1_VALIDATION_MSG: "Please enter an address",
                ADDRESS3_LBL: "@:COMMON.TERMINOLOGY.ADDRESS3",
                ADDRESS4_LBL: "@:COMMON.TERMINOLOGY.ADDRESS4",
                POSTCODE_LBL: "@:COMMON.TERMINOLOGY.POSTCODE"
            },
            QUICK_PICK: {
                BLOCK_WHOLE_DAY: "Block whole day",
                BLOCK_TIME_TAB_HEADING: "Block time",
                MAKE_BOOKING_TAB_HEADING: "Make booking",
                FOR: "For",
                PERSON_LABEL: "@:COMMON.TERMINOLOGY.PERSON",
                PERSON_DEFAULT_OPTION: "Any Person",
                RESOURCE_LABEL: "@:COMMON.TERMINOLOGY.RESOURCE",
                RESOURCE_DEFAULT_OPTION: "Any Resource",
                FROM_LBL: "From",
                SERVICE_LABEL: 'Select a service',
                SERVICE_DEFAULT_OPTION: "-- select --",
                SERVICE_REQUIRED_MSG: 'Please select a service',
                TO_LBL: "To",
                YES_OPTION: "@:COMMON.BTN.YES",
                NO_OPTION: "@:COMMON.BTN.NO",
                NEXT_BTN: "@:COMMON.BTN.NEXT",
                BLOCK_TIME_BTN: "Block Time",
                FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
            },
            BOOKINGS_TABLE: {
                CANCEL_BTN: "@:COMMON.BTN.CANCEL",
                DETAILS_BTN: "@:COMMON.BTN.DETAILS"
            },
            ADMIN_MOVE_BOOKING: {
                CANCEL_CONFIRMATION_HEADING: "Your booking has been cancelled.",
                HEADING: "Your {{service_name}} booking",
                CUSTOMER_NAME_LBL: "@:COMMON.TERMINOLOGY.NAME",
                PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                WHEN_LBL: "@:COMMON.TERMINOLOGY.WHEN",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING",
                MOVE_BOOKING_BTN: "Move booking",
                BOOK_WAITLIST_ITEMS_BTN: "Book Waitlist Items"
            },
            CHECK_ITEMS: {
                BOOKINGS_QUESTIONS_HEADING: "Booking Questions",
                PRIVATE_BOOKING_NOTES_HEADING: "Private Notes",
                BOOK_BTN: "@:COMMON.BTN.BOOK",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            CONFIRMATION: {
                TITLE: "@:COMMON.TERMINOLOGY.CONFIRMATION",
                BOOKING_CONFIRMATION: "Booking is now confirmed.",
                EMAIL_CONFIRMATION: "An email has been sent to {{customer_name}} with the details below.",
                WAITLIST_CONFIRMATION: "You have successfully made the following bookings.",
                PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT",
                PURCHASE_REF_LBL: "Reference",
                CUSTOMER_LBL: "@:COMMON.TERMINOLOGY.BOOKING_REF",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                DATE_TIME_LBL: "@:COMMON.TERMINOLOGY.DATE_TIME",
                TIME_LBL: "@:COMMON.TERMINOLOGY.TIME",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                CLOSE_BTN: "@:COMMON.BTN.CLOSE"
            }
        }
    };

    $translateProvider.translations("en", translations);

});
