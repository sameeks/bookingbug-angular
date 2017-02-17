angular.module('BB.Services').config(function ($translateProvider) {
    'ngInject';

    let translations = {
        CORE: {
            ALERTS: {
                ERROR_HEADING: "Error",
                ACCOUNT_DISABLED: "Your account appears to be disabled. Please contact the business you're booking with if the problem persists.",
                ALREADY_REGISTERED: "You have already registered with this email address. Please login or reset your password.",
                APPT_AT_SAME_TIME: "Your appointment is already booked for this time",
                ATTENDEES_CHANGED: "Your booking has been successfully updated",
                EMAIL_IN_USE: "There's already an account registered with this email. Use the search field to find the customer's account.",
                EMPTY_BASKET_FOR_CHECKOUT: "You need to add some items to the basket before you can checkout.",
                FB_LOGIN_NOT_A_MEMBER: "Sorry, we couldn't find a login associated with this Facebook account. You will need to sign up using Facebook first",
                FORM_INVALID: "Please complete all required fields",
                GENERIC: "Sorry, it appears that something went wrong. Please try again or call the business you're booking with if the problem persists.",
                GEOLOCATION_ERROR: "Sorry, we could not determine your location. Please try searching instead.",
                GIFT_CERTIFICATE_REQUIRED: "A valid Gift Certificate is required to proceed with this booking",
                POSTCODE_INVALID: "@:COMMON.TERMINOLOGY.POSTCODE_INVALID",
                ITEM_NO_LONGER_AVAILABLE: "Sorry. The item you were trying to book is no longer available. Please try again.",
                NO_WAITLIST_SPACES_LEFT: "Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available",
                LOCATION_NOT_FOUND: "Sorry, we don't recognise that location",
                LOGIN_FAILED: "Sorry, your email or password was not recognised. Please try again or reset your password.",
                SSO_LOGIN_FAILED: "Something went wrong when trying to log you in. Please try again.",
                MAXIMUM_TICKETS: "Sorry, the maximum number of tickets per person has been reached.",
                MISSING_LOCATION: "Please enter your location",
                MISSING_POSTCODE: "Please enter a postcode",
                PASSWORD_INVALID: "Sorry, your password is invalid",
                PASSWORD_MISMATCH: "Your passwords don't match",
                PASSWORD_RESET_FAILED: "Sorry, we couldn't update your password. Please try again.",
                PASSWORD_RESET_REQ_FAILED: "Sorry, we didn't find an account registered with that email.",
                PASSWORD_RESET_REQ_SUCCESS: "We have sent you an email with instructions on how to reset your password.",
                PASSWORD_RESET_SUCESS: "Your password has been updated.",
                PAYMENT_FAILED: "We were unable to take payment. Please contact your card issuer or try again using a different card",
                PHONE_NUMBER_IN_USE: "There's already an account registered with this phone number. Use the search field to find the customer's account.",
                REQ_TIME_NOT_AVAIL: "The requested time slot is not available. Please choose a different time.",
                TIME_SLOT_NOT_SELECTED: "You need to select a time slot",
                STORE_NOT_SELECTED: "You need to select a store",
                TOPUP_FAILED: "Sorry, your topup failed. Please try again.",
                TOPUP_SUCCESS: "Your wallet has been topped up",
                UPDATE_FAILED: "Update failed. Please try again",
                UPDATE_SUCCESS: "Updated",
                WAITLIST_ACCEPTED: "Your booking is now confirmed!",
                BOOKING_CANCELLED: "Your booking has been cancelled.",
                NOT_BOOKABLE_PERSON: "Sorry, this person does not offer this service, please select another",
                NOT_BOOKABLE_RESOURCE: "Sorry, resource does not offer this service, pelase select another",
                SPEND_AT_LEAST: "You need to spend at least {{min_spend | pretty_price}} to make a booking.",
                COUPON_APPLY_FAILED: "Sorry, your coupon could not be applied. Please try again.",
                DEAL_APPLY_FAILED: "Sorry, your deal code could not be applied. Please try again.",
                DEAL_REMOVE_FAILED: "Sorry, we were unable to remove that deal. Please try again."
            },
            PAGINATION: {
                SUMMARY: "{{start}} - {{end}} of {{total}}"
            },
            MODAL: {
                CANCEL_BOOKING: {
                    HEADER: "Cancel",
                    QUESTION: "Are you sure you want to cancel this {{type}}?"
                },
                SCHEMA_FORM: {
                    OK_BTN: "@:COMMON.BTN.OK",
                    CANCEL_BTN: "@:COMMON.BTN.CANCEL"
                }
            },
            TIMEZONE_INFO: "All times are shown in {{time_zone_name}}.",
            FILTERS: {
                DISTANCE: {
                    MILES: "miles",
                    KILOMETRES: "km"
                },
                CURRENCY: {
                    THOUSANDS_SEPARATOR: ",",
                    DECIMAL_SEPARATOR: ".",
                    CURRENCY_FORMAT: "%s%v"
                },
                PRETTY_PRICE: {
                    FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
                },
                TIME_PERIOD: {
                    TIME_PERIOD: "{hours, plural, =0{} one{1 hour} other{# hours}}{show_seperator, plural, =0{} =1{, } other{}}{minutes, plural, =0{} one{1 minute} other{# minutes}}"
                }
            },
            EVENT: {
                SPACES_LEFT: "Only {N, plural, one{one space}, other{# spaces}} left",
                JOIN_WAITLIST: "Join waitlist"
            }
        },
        COMMON: {
            TERMINOLOGY: {
                CATEGORY: "Category",
                DURATION: "Duration",
                RESOURCE: "Resource",
                PERSON: "Person",
                SERVICE: "Service",
                WALLET: "Wallet",
                SESSION: "Session",
                EVENT: "Event",
                EVENTS: "Events",
                COURSE: "Course",
                COURSES: "Courses",
                DATE: "Date",
                TIME: "Time",
                DATE_TIME: "Date/Time",
                WHEN: "When",
                GIFT_CERTIFICATE: "Gift Certificate",
                GIFT_CERTIFICATES: "Gift Certificates",
                ITEM: "Item",
                FILTER: "Filter",
                ANY: "Any",
                RESET: "Reset",
                TOTAL: "Total",
                TOTAL_DUE_NOW: "Total Due Now",
                BOOKING_FEE: "Booking Fee",
                PRICE: "Price",
                PRICE_FREE: "Free",
                PRINT: "Print",
                AND: "and",
                APPOINTMENT: "Appointment",
                TICKETS: "Tickets",
                TYPE: "Type",
                EXPORT: "Export",
                RECIPIENT: "Recipient",
                BOOKING_REF: "Booking Reference",
                MORNING: "Morning",
                AFTERNOON: "Afternoon",
                EVENING: "Evening",
                AVAILABLE: "Available",
                UNAVAILABLE: "Unavailable",
                CALENDAR: "Calendar",
                QUESTIONS: "Questions",
                BOOKING: "Booking",
                ADMITTANCE: "Admittance",
                EDIT: "Edit",
                CONFIRMATION: "Confirmation",
                NAME: "Name",
                FIRST_NAME: "First Name",
                LAST_NAME: "Last Name",
                ADDRESS1: "Address",
                ADDRESS3: "Town",
                ADDRESS4: "County",
                POSTCODE: "Postcode",
                PHONE: "Phone",
                MOBILE: "Mobile",
                EMAIL: "Email",
                SCHEDULE: "Schedule",
                SEARCH: "Search",
                STAFF: "Staff",
                RESOURCES: "Resources"
            },
            FORM: {
                FIRST_NAME_REQUIRED: "Please enter your first name",
                LAST_NAME_REQUIRED: "Please enter your last name",
                ADDRESS_REQUIRED: "Please enter your address",
                POSTCODE_INVALID: "Please enter a valid postcode",
                PHONE_INVALID: "Please enter a valid phone number",
                MOBILE_INVALID: "Please enter a valid mobile number",
                EMAIL_REQUIRED: "Please enter your email",
                EMAIL_INVALID: "Please enter a valid email address",
                FIELD_REQUIRED: "This field is required",
                PASSWORD: "Password",
                PASSWORD_REQUIRED: "Please enter your password",
                CONFIRM_PASSWORD: "Confirm password",
                PASSWORD_MISMATCH: "Please ensure your passwords match",
                PASSWORD_LENGTH: "Password must be at least 7 characters",
                REQUIRED: "*Required",
                TERMS_AND_CONDITIONS: "I agree to the terms and conditions",
                TERMS_AND_CONDITIONS_REQUIRED: "Please accept the terms and conditions"
            },
            BTN: {
                CANCEL: "Cancel",
                CLOSE: "Close",
                NO: "No",
                OK: "Ok",
                YES: "Yes",
                BACK: "Back",
                NEXT: "Continue",
                LOGIN: "Login",
                CONFIRM: "Confirm",
                SAVE: "Save",
                SELECT: "Select",
                BOOK: "Book",
                BOOK_EVENT: "Book Event",
                CANCEL_BOOKING: "Cancel Booking",
                DO_NOT_CANCEL_BOOKING: "Do not cancel",
                APPLY: "Apply",
                CLEAR: "Clear",
                PAY: "Pay",
                CHECKOUT: "Checkout",
                TOP_UP: "Top Up",
                ADD: "Add",
                SUBMIT: "Submit",
                DETAILS: "Details",
                MORE: "More",
                LESS: "Less",
                DELETE: "Delete",
                BUY: "Buy"
            },
            LANGUAGE: {
                EN: "English",
                DE: "Deutsch",
                ES: "Español",
                FR: "Français"
            }
        }
    };

    $translateProvider.translations('en', translations);

});
