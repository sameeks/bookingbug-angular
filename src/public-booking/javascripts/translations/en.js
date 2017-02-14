// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BB.Services").config(function ($translateProvider) {
    "ngInject";

    let translations = {
        PUBLIC_BOOKING: {
            ACCORDION_RANGE_GROUP: {
                NUM_SLOTS_AVAILABLE: "{SLOTS_NUMBER, plural, =0{0 available} =1{1 available} other{{SLOTS_NUMBER} available}}"
            },
            ITEM_DETAILS: {
                MOVE_BOOKING_SUCCESS_ALERT: "Your booking has been moved to {{datetime | datetime: 'LLLL'}}",
                MOVE_BOOKING_FAIL_ALERT: "Failed to move booking. Please try again.",
                FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
            },
            ADD_RECIPIENT: {
                MODAL_HEADING: "@:COMMON.TERMINOLOGY.RECIPIENT",
                WHO_TO_QUESTION: "Who should we send the gift voucher to?",
                WHO_TO_OPTION_ME: "Me",
                WHO_TO_OPTION_NOT_ME: "Someone else",
                NAME_LBL: "@:COMMON.TERMINOLOGY.NAME",
                NAME_REQUIRED: "Please enter the recipient's name",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID",
                EMAIL_REQUIRED: "Please enter the recipient's email address",
                ADD_LBL: "Add Recipient",
                CANCEL_LBL: "@:COMMON.BTN.CANCEL"
            },
            BASKET_DETAILS: {
                MODAL_HEADING: "Basket Details",
                NO_ITEMS_IN_BASKET: "No items added to basket yet.",
                ITEM_COL_HEADING: "@:COMMON.TERMINOLOGY.ITEM",
                TIME_DURATION_COL_HEADING: "@:COMMON.TERMINOLOGY.APPOINTMENT",
                ITEM_TIME_AND_DURATION: "{{time | datetime: 'LLLL'}} for {{duration | time_period}}",
                CANCEL_BTN: "@:COMMON.BTN.CANCEL",
                CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT",
                BASKET_STATUS: "{N, plural, =0{empty} one{One item in your basket} other{#items in your basket}}"
            },
            BASKET_ITEM_SUMMARY: {
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                DURATION_LBL: "@:COMMON.TERMINOLOGY.DURATION",
                RESOURCE_LBL: "@:COMMON.TERMINOLOGY.RESOURCE",
                PERSON_LBL: "@:COMMON.TERMINOLOGY.PERSON",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                DATE_LBL: "@:COMMON.TERMINOLOGY.DATE",
                TIME_LBL: "@:COMMON.TERMINOLOGY.TIME"
            },
            CALENDAR: {
                NEXT_BTN: "@:COMMON.BTN.NEXT",
                MOVE_BOOKING_BTN: "@:COMMON.BTN.BOOK",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            CATEGORY: {
                STEP_DESCRIPTION: "Select appointment type",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            CANCEL_MODAL: {
                MODAL_HEADING: "Are you sure you want to cancel this booking?",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                WHEN_LBL: "@:COMMON.TERMINOLOGY.WHEN",
                CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING",
                DONT_CANCEL_BOOKING_BTN: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
            },
            CHECK_ITEMS: {
                STEP_HEADING: "Review",
                BOOKING_QUESTIONS_HEADING: "Your Booking",
                NEXT_BTN: "@:COMMON.BTN.NEXT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            CHECKOUT: {
                STEP_HEADING: "Payment",
                PAYMENT_DETAILS_HEADING: "Payment Details",
                PAY_BTN: "@:COMMON.BTN.PAY"
            },
            CHECKOUT_EVENT: {
                STEP_DESCRIPTION: "Please complete payment to confirm your booking.",
                TICKETS_HEADER: "@:COMMON.TERMINOLOGY.TICKETS",
                TYPE_COL_HEADING: "Type",
                PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE",
                QTY_COL_HEADING: "Qty",
                PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE",
                BASKET_TOTAL_LBL: "@:COMMON.TERMINOLOGY.TOTAL",
                FOR_NUM_TICKETS: "(for {{count_as}})",
                PAY_BTN: "@:COMMON.BTN.PAY"
            },
            CLIENT: {
                STEP_HEADING: "Your Details",
                ADMIN_STEP_HEADING: "Customer Details"
            },
            COMPANY_CARDS: {
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            COMPANY_LIST: {
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            CONFIRMATION: {
                TITLE: "@:COMMON.TERMINOLOGY.CONFIRMATION",
                BOOKING_CONFIRMATION: "Thanks {{member_name}}. Your booking is now confirmed. We have emailed you the details below.",
                WAITLIST_CONFIRMATION: "Thanks {{member_name}}. You have successfully made the following bookings. We have you emailed you the details below.",
                PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT",
                PURCHASE_REF_LBL: "Purchase Reference",
                BOOKING_REF_LBL: "@:COMMON.TERMINOLOGY.BOOKING_REF",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                DATE_TIME_LBL: "@:COMMON.TERMINOLOGY.DATE_TIME",
                TIME_LBL: "@:COMMON.TERMINOLOGY.TIME",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
            },
            MEMBER_LOGIN_FORM: {
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED",
                EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID",
                PASSWORD_LBL: "@:COMMON.FORM.PASSWORD",
                PASSWORD_REQURIED: "@:COMMON.FORM.PASSWORD_REQUIRED",
                REMEMBER_ME: "Remember me",
                LOGIN_BTN: "@:COMMON.BTN.LOGIN"
            },
            MONTH_PICKER: {
                BACK_BTN: "Previous",
                NEXT_BTN: "Next"
            },
            POPOUT_EXPORT_BOOKING: {
                LONG_EXPORT_LBL: "Export to calendar",
                SHORT_EXPORT_LBL: "@:COMMON.TERMINOLOGY.EXPORT"
            },
            PRICE_FILTER: {
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
            },
            SERVICE_LIST_FILTER: {
                FILTER_HEADING: "@:COMMON.TERMINOLOGY.FILTER",
                CATEGORY_LBL: "@:COMMON.TERMINOLOGY.CATEGORY",
                ANY_CATEGORY: "Any Category",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE",
                RESET_BTN: "@:COMMON.TERMINOLOGY.RESET"
            },
            WEEK_CALENDAR: {
                NO_AVAILABILITY: "It looks like there's no availability for the next {time_range_length, plural, one{day} other{# days}}",
                NEXT_AVAIL_BTN: "Jump to Next Available Day",
                DATE_LBL: "@:COMMON.TERMINOLOGY.DATE",
                DATE_BTN_TITLE: "Pick date",
                ANY_DATE: "- Any Date -",
                MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING",
                AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON",
                EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
            },
            BASKET: {
                TITLE: "Your basket",
                NO_ITEMS_HEADING: "There are no items in the basket",
                NO_ITEMS_DESCRIBE: "Please press the add another item button if you wish to add a product or service.",
                ITEM_COL_HEADING: "@:COMMON.TERMINOLOGY.ITEM",
                PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE",
                RECIPIENT_LBL: "@:COMMON.TERMINOLOGY.RECIPIENT",
                GIFT_CERT_PAID_LBL: "Certificate Paid",
                GIFT_CERT_HEADING: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES",
                ORIGINAL_PRICE_LBL: "Original Price",
                BOOKING_FEE_LBL: "@:COMMON.TERMINOLOGY.BOOKING_FEE",
                GIFT_CERT_TOTAL_LBL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES",
                GIFT_CERT_BALANCE_LBL: "Remaining Value on Gift Certificate",
                COUPON_DISCOUNT_LBL: "Coupon Discount",
                TOTAL_LBL: "@:COMMON.TERMINOLOGY.TOTAL",
                TOTAL_DUE_NOW_LBL: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW",
                WALLET: {
                    HEADING: "@:COMMON.TERMINOLOGY.WALLET",
                    BALANCE_LBL: "Current Wallet Balance",
                    BALANCE_INSUFFICIENT: "You do not currently have enough money in your wallet account. You can either pay the full amount, or top up to add more money to your wallet.",
                    REMAINDER: "You will have {{remainder | currency}} left in your wallet after this purchase",
                    TOP_UP_BTN: "@:COMMON.BTN.TOP_UP"
                },
                APPLY_COUPON_LBL: "Apply a coupon",
                APPLY_COUPON_BTN: "@:COMMON.BTN.APPLY",
                GIFT_CERTIFICATE: {
                    QUESTION: "Have a gift certificate?",
                    APPLY_LBL: "Apply a Gift Certificate",
                    APPLY_ANOTHER_LBL: "Apply another Gift Certificate",
                    CODE_PLACEHOLDER: "Enter a certificate code",
                    APPLY_BTN: "@:COMMON.BTN.APPLY"
                },
                ADD_ANOTHER_EVENT_BTN: "Add another event",
                ADD_ANOTHER_SERVICE_BTN: "Add another service",
                CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            BASKET_SUMMARY: {
                STEP_HEADING: "Summary",
                STEP_DESCRIPTION: "Please review the following information",
                DATE_TIME_LBL: "@:COMMON.TERMINOLOGY.DATE_TIME",
                DURATION_LBL: "@:COMMON.TERMINOLOGY.DURATION",
                NAME_LBL: "@:COMMON.TERMINOLOGY.NAME",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE",
                ADDRESS_LBL: "@:COMMON.TERMINOLOGY.ADDRESS1",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                CONFIRM_BTN: "@:COMMON.BTN.CONFIRM",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            BOOK_WAITLIST: {
                STEP_HEADING: "Your Waitlist {num_bookings, plural =1{Booking} other{Bookings}}",
                BOOKING_REF_LBL: "@:COMMON.TERMINOLOGY.BOOKING_REF",
                SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE",
                DATE_TIME_LBL: "@:COMMON.TERMINOLOGY.DATE_TIME",
                PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                BOOK_BTN: "@:COMMON.BTN.BOOK",
                TOTAL_LBL: "@:COMMON.TERMINOLOGY.TOTAL",
                TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW",
                BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL",
                BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW",
                BOOKING_CONFIRMATION: "Thanks {{member_name}}. You have successully booked onto {{purchase_item}}.",
                PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            ERROR_MODAL: {
                OK_BTN: "@:COMMON.BTN.OK"
            },
            MEMBER_FORM: {
                FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME",
                LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                PHONE_LBL: "@:COMMON.TERMINOLOGY.PHONE",
                MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE",
                SAVE_BTN: "@:COMMON.BTN.SAVE"
            },
            BASKET_WALLET: {
                STEP_HEADING: "Make Payment",
                SHOW_TOP_UP_FORM_BTN: "@:COMMON.BTN.TOP_UP",
                TOP_UP_BTN: "Top up Wallet",
                AMOUNT_BY_LBL: "Amount",
                BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET",
                MINIMUM_AMOUNT_WARNING: "Minimum top up amount must be greater than {{min_amount | currency}}",
                BACK_BTN: "@:COMMON.BTN.BACK",
                TOPUP_AMOUNT_PLACEHOLDER: "Enter Top Up Amount"
            },
            DASH: {
                TITLE: "Dashboard",
                DESCRIPTION: "Pick a Location/Person"
            },
            MONTH_CALENDAR: {
                PREV_MONTH_BTN: "Previous Month",
                NEXT_MONTH_BTN: "Next Month",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            DEAL_LIST: {
                HEADING: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES",
                BUY_GIFT_CERT_BTN: "Buy Gift Certificates",
                SELECTED_CERTS_HEADING: "Selected Gift Certificates",
                CERTIFICATE_COL_HEADING: "@:COMMON.TERMINOLOGY.ITEM",
                PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE",
                RECIPIENT_FORM: {
                    HEADING: "Add Recipient",
                    RECIPIENT_NAME_LBL: "Recipient Name",
                    EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                    ADD_RECIPIENT_BTN: "Add",
                    NAME_REQUIRED: "Please enter your name",
                    EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
                },
                RECIPIENT_HEADING: "@:COMMON.TERMINOLOGY.RECIPIENT",
                RECIPIENT_NAME_LBL: "@:COMMON.TERMINOLOGY.NAME",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                BUY_BTN: "@:COMMON.BTN.BUY",
                BACK_BTN: "@:COMMON.BTN.BACK",
                CERT_NOT_SELECTED_ALERT: "You need to select at least one Gift Certificate to continue"
            },
            DURATION_LIST: {
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK",
                DURATON_NOT_SELECTED_ALERT: "You need to select a duration"
            },
            EVENT: {
                EVENT_DETAILS_HEADING: "Event details",
                TICKET_TYPE_COL_HEADING: "@:COMMON.TERMINOLOGY.TYPE",
                TICKET_PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE",
                TICKET_QTY_COL_HEADING: "Qty",
                EVENT_SOLD_OUT: "Sold Out",
                ADD_ONS_LBL: "Add-ons",
                SUBTOTAL_LBL: "Subtotal",
                GIFT_CERT_LBL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATE",
                DISCOUNT_LBL: "Discount",
                BASKET_TOTAL_LBL: "@:COMMON.TERMINOLOGY.TOTAL",
                BASKET_TOTAL_DUE_LBL: "Total Due",
                CUSTOMER_DETAILS_HEADING: "Your details",
                FOR_NUM_TICKETS: "(for {{count_as}})",
                TICKET_ACCORDION: {
                    HEADING: "Ticket {num_tickets, plural, =0{details} other{{ticket_number} details}}",
                    ATTENDEE_IS_YOU_QUESTION: "Are you the attendee?",
                    ATTENDEE_USE_MY_DETAILS: "Yes, use my details",
                    FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME",
                    FIRST_NAME_REQUIRED: "Please enter the attendee's first name",
                    LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME",
                    LAST_NAME_REQUIRED: "Please enter the attendee's last name",
                    EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                    EMAIL_REQUIRED: "Please enter the attendee's email address",
                    EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
                },
                T_AND_C_LBL: "@:COMMON.FORM.TERMS_AND_CONDITIONS",
                T_AND_C_REQUIRED: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED",
                RESERVE_TICKET_BTN: "Reserve {num_tickets, plural, =0{Ticket} one{Ticket} other{Tickets}}",
                JOIN_WAITLIST_BTN: "Join Waitlist",
                BOOK_TICKET_BTN: "Book {num_tickets, plural, =0{Ticket} one{Ticket} other{Tickets}}",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            EVENT_GROUP_LIST: {
                SELECT_BTN: "@:COMMON.BTN.SELECT"
            },
            EVENT_LIST: {
                HEADING: "Events at {{company_name}}",
                FILTER: {
                    HEADING: "@:COMMON.TERMINOLOGY.FILTER",
                    CATEGORY_LBL: "@:COMMON.TERMINOLOGY.CATEGORY",
                    ANY_CATEGORY_OPTION: "- Any Category -",
                    ANY_OPTION: "- Any {{filter_name}} -",
                    PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE",
                    ANY_PRICE_OPTION: "- Any Price -",
                    DATE_LBL: "@:COMMON.TERMINOLOGY.DATE",
                    DATE_PICKER_HEADING: "Pick date",
                    DATE_PICKER_PLACEHOLDER: "- Any Date -",
                    HIDE_FULLY_BOOKED_EVENTS: "Hide Fully Booked Events",
                    SHOW_FULLY_BOOKED_EVENTS: "Show Fully Booked Events",
                    RESET_FILTER_BTN: "@:COMMON.TERMINOLOGY.RESET",
                    NO_FILTER_APPLIED: "Showing all events",
                    FILTER_APPLIED: "Showing filtered events"
                },
                NO_EVENTS: "No events found",
                SPACES_LEFT: "{spaces_left, plural, =0{No spaces} one{# space} other{# spaces}} left",
                PRICE_FROM: "From {{min_ticket_price | pretty_price}}",
                BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK_EVENT",
                EVENT_SOLD_OUT: "Sold out",
                JOIN_WAITLIST_BTN: "Join Waitlist",
                MORE_INFO: "More Info",
                LESS_INFO: "Less Info",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            MAIN: {
                POWERED_BY: "Bookings powered by"
            },
            MAP: {
                SEARCH_LBL: "@:COMMON.TERMINOLOGY.SEARCH",
                SEARCH_BTN: "@:COMMON.TERMINOLOGY.SEARCH",
                SEARCH_PLACEHOLDER: "Enter a town, city, postcode or store",
                GEOLOCATE_BTN_HEADING: "Use current location",
                SEARCH_RESULT_SUMMARY: "{results, plural, =0{No results} one{1 result} other{# results}} for stores near {address}",
                HIDE_STORES_LBL: "Hide stores with no availability",
                SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                STORE_ACCORDION: {
                    SELECT_BTN: "@:COMMON.BTN.SELECT",
                    SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
                }
            },
            MEMBERSHIP_LEVELS: {
                STEP_HEADING: "Membership Types",
                SELECT_BTN: "@:COMMON.BTN.SELECT"
            },
            LOGIN: {
                HEADING: "Login",
                NO_ACCOUNT: "Don't have an account?",
                REGISTER_BTN: "Register"
            },
            TIME: {
                PREV_DAY_BTN: "Previous Day",
                NEXT_DAY_BTN: "Next Day",
                NO_AVAILABILITY: "No availability",
                BACK_BTN: "@:COMMON.BTN.BACK",
                TIME_NOT_SELECTED_ALERT: "Please select a time slot",
                MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING",
                AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON",
                EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
            },
            SURVEY: {
                SURVEY_THANK_YOU: "Thank you for filling out the survey!",
                SESSION_LBL: "@:COMMON.TERMINOLOGY.SESSION",
                DATE_LBL: "@:COMMON.TERMINOLOGY.DATE",
                SURVEY_QUESTIONS_HEADING: "Survey Questions",
                SUBMIT_SURVEY_BTN: "@:COMMON.BTN.SUBMIT",
                NO_QUESTIONS: "No survey questions for this session."
            },
            SERVICE_LIST: {
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            SERVICES: {
                SELECT_BTN: "@:COMMON.BTN.SELECT"
            },
            RESOURCE_LIST: {
                STEP_DESCRIPTION: "Select a resource to continue making a booking.",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            RESCHEDULE_REASONS: {
                MOVE_HEADING: "Move Appointment",
                MOVE_REASON: "Please select a reason for moving your appointment:",
                MOVE_BTN: "Move Appointment"
            },
            PURCHASE: {
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
            PRINT_PURCHASE: {
                TITLE: "Booking Confirmation",
                BOOKING_CONFIRMATION: "Thanks {{member_name}}. Your booking is now confirmed. We have emailed you the details below.",
                EXPORT_BOOKING_BTN: "@:COMMON.TERMINOLOGY.EXPORT",
                PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT",
                ITEM_LBL: "@:COMMON.TERMINOLOGY.ITEM",
                DATE_TIME_LBL: "@:COMMON.TERMINOLOGY.DATE_TIME",
                QTY_LBL: "Quantity",
                BOOKING_REFERENCE_LBL: "@:COMMON.TERMINOLOGY.BOOKING_REF",
                POWERED_BY: "Bookings powered by"
            },
            PERSON_LIST: {
                STEP_DESCRIPTION: "Select a person to continue making a booking.",
                SELECT_BTN: "@:COMMON.BTN.SELECT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            DAY: {
                STEP_HEADING: "Select a day",
                WEEK_BEGINNING_LBL: "Week beginning:",
                SELECT_DATE_BTN_TITLE: "Pick a date",
                PREVIOUS_5_WEEKS_BTN: "Previous 5 Weeks",
                NEXT_5_WEEKS_BTN: "Next 5 Weeks",
                LEGEND: {
                    HEADING: "Key",
                    AVAILABLE_KEY: "{number, plural, =0{No availability} other{# available}}",
                    UNAVAILABLE_KEY: "@:COMMON.TERMINOLOGY.UNAVAILABLE"
                },
                BACK_BTN: "@:COMMON.BTN.BACK"
            },
            REGISTER: {
                HEADING: "Register",
                REGISTER_BTN: "Register"
            },
            MAIN_ACCOUNT: {
                ACCOUNT_TAB_HEADING: "Account",
                UPCOMING_BOOKINGS_TAB_HEADING: "Upcoming Bookings",
                PAST_BOOKINGS_TAB_HEADING: "Past Bookings",
                WALLET_TAB_HEADING: "Wallet"
            },
            ACCOUNT: {
                HEADING: "My Details"
            },
            CLIENT_FORM: {
                FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME",
                FIRST_NAME_REQUIRED: "@:COMMON.FORM.FIRST_NAME_REQUIRED",
                LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME",
                LAST_NAME_REQUIRED: "@:COMMON.FORM.LAST_NAME_REQUIRED",
                EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL",
                EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED",
                EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID",
                PASSWORD_LBL: "@:COMMON.FORM.PASSWORD",
                PASSWORD_REQUIRED: "@:COMMON.FORM.PASSWORD_REQUIRED",
                PASSWORD_LENGTH: "@:COMMON.FORM.PASSWORD_LENGTH",
                CONFIRM_PASSWORD_LBL: "@:COMMON.FORM.CONFIRM_PASSWORD",
                PASSWORD_MISMATCH: "@:COMMON.FORM.PASSWORD_MISMATCH",
                MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE",
                MOBILE_INVALID: "@:COMMON.FORM.MOBILE_INVALID",
                PHONE_LBL: "@:COMMON.TERMINOLOGY.PHONE",
                PHONE_INVALID: "@:COMMON.FORM.PHONE_INVALID",
                ADDRESS_LBL: "@:COMMON.TERMINOLOGY.ADDRESS1",
                ADDRESS_REQUIRED: "@:COMMON.FORM.ADDRESS_REQUIRED",
                ADDRESS_3_LBL: "@:COMMON.TERMINOLOGY.ADDRESS3",
                ADDRESS_4_LBL: "@:COMMON.TERMINOLOGY.ADDRESS4",
                ADDRESS_5_LBL: "@:COMMON.FORM.ADDRESS5",
                POSTCODE_LBL: "@:COMMON.TERMINOLOGY.POSTCODE",
                POSTCODE_INVALID: "@:COMMON.FORM.POSTCODE_INVALID",
                CLIENT_QUESTIONS_HEADING: "Additional Information",
                FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED",
                NEXT_BTN: "@:COMMON.BTN.NEXT",
                BACK_BTN: "@:COMMON.BTN.BACK"
            }

        }
    };

    $translateProvider.translations("en", translations);

});
