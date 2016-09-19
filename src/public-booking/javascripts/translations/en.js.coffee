'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: '{SLOTS_NUMBER, plural, =0{no time} =1{1 time} other{{SLOTS_NUMBER} times}} available'
      }
      ALERTS: {
        ACCOUNT_DISABLED: "Your account appears to be disabled. Please contact the business you're booking with if the problem persists."
        ALREADY_REGISTERED: "You have already registered with this email address. Please login or reset your password."
        APPT_AT_SAME_TIME: "Your appointment is already booked for this time"
        ATTENDEES_CHANGED: "Your booking has been successfully updated"
        EMAIL_ALREADY_REGISTERED_ADMIN: "There's already an account registered with this email. Use the search field to find the customers account."
        EMPTY_BASKET_FOR_CHECKOUT:"You need to add some items to the basket before you can checkout."
        FB_LOGIN_NOT_A_MEMBER: "Sorry, we couldn't find a login associated with this Facebook account. You will need to sign up using Facebook first"
        FORM_INVALID: "Please complete all required fields"
        GENERIC:"Sorry, it appears that something went wrong. Please try again or call the business you're booking with if the problem persists."
        GEOLOCATION_ERROR: "Sorry, we could not determine your location. Please try searching instead."
        GIFT_CERTIFICATE_REQUIRED: "A valid Gift Certificate is required to proceed with this booking"
        INVALID_POSTCODE: "Please enter a valid postcode"
        ITEM_NO_LONGER_AVAILABLE: "Sorry. The item you were trying to book is no longer available. Please try again."
        NO_WAITLIST_SPACES_LEFT: "Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available"
        LOCATION_NOT_FOUND: "Sorry, we don't recognise that location"
        LOGIN_FAILED: "Sorry, your email or password was not recognised. Please try again or reset your password."
        SSO_LOGIN_FAILED: "Something went wrong when trying to log you in. Please try again."
        MAXIMUM_TICKETS: "Sorry, the maximum number of tickets per person has been reached.",
        MISSING_LOCATION: "Please enter your location"
        MISSING_POSTCODE: "Please enter a postcode"
        PASSWORD_INVALID: "Sorry, your password is invalid"
        PASSWORD_MISMATCH: "Your passwords don't match"
        PASSWORD_RESET_FAILED: "Sorry, we couldn't update your password. Please try again."
        PASSWORD_RESET_REQ_FAILED: "Sorry, we didn't find an account registered with that email."
        PASSWORD_RESET_REQ_SUCCESS: "We have sent you an email with instructions on how to reset your password."
        PASSWORD_RESET_SUCESS: "Your password has been updated."
        PAYMENT_FAILED: "We were unable to take payment. Please contact your card issuer or try again using a different card"
        PHONE_NUMBER_ALREADY_REGISTERED_ADMIN: "There's already an account registered with this phone number. Use the search field to find the customers account."
        REQ_TIME_NOT_AVAIL: "The requested time slot is not available. Please choose a different time."
        TIME_SLOT_NOT_SELECTED: "You need to select a time slot"
        STORE_NOT_SELECTED: "You need to select a store"
        TOPUP_FAILED: "Sorry, your topup failed. Please try again."
        TOPUP_SUCCESS: "Your wallet has been topped up"
        UPDATE_FAILED: "Update failed. Please try again"
        UPDATE_SUCCESS: "Updated"
        WAITLIST_ACCEPTED: "Your booking is now confirmed!"
        BOOKING_CANCELLED: "Your booking has been cancelled."
        NOT_BOOKABLE_PERSON: "Sorry, this person does not offer this service, please select another"
        NOT_BOOKABLE_RESOURCE: "Sorry, resource does not offer this service, pelase select another"
        SPEND_AT_LEAST: "You need to spend at least {{min_spend | pretty_price}} to make a booking.",
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_MSG: "Your booking has been moved to {{datetime | datetime: 'LLLL'}}"
        MOVE_BOOKING_FAIL_MSG: "Failed to move booking. Please try again."
      }
      ADD_RECIPIENT: {
        MODAL_TITLE: "Recipient",
        WHO_TO_QUESTION: "Who should we send the gift voucher to?"
        WHO_TO_OPTION_ME: "Me",
        WHO_TO_OPTION_NOT_ME: "Someone else"
        NAME_LABEL: "Name",
        NAME_VALIDATION_MSG: "Please enter the recipient's full name"
        EMAIL_LABEL: "Email"
        EMAIL_VALIDATION_MSG: "Please enter a valid email address"
        ADD_LABEL: "Add Recipient"
        CANCEL_LABEL: "Cancel"
      }
      BASKET_DETAILS: {
        BASKET_DETAILS_TITLE: "Basket Details"
        BASKET_DETAILS_NO: "No items added to basket yet."
        ITEM: "Item"
        BASKET_ITEM_APPOINTMENT: "Appointment"
        TIME_AND_DURATION: "{{time | datetime: 'LLLL'}} for {{duration | time_period}}"
        PROGRESS_CANCEL: "Cancel"
        BASKET_CHECKOUT: "Checkout"
        BASKET_STATUS: "{N, plural, =0 {empty}, one {One item in your basket}, others {#items in your basket}}"
      }
      BASKET_ITEM_SUMMARY: {
        ITEM_DURATION: "Duration"
        ITEM_RESOURCE: "Resource"
        ITEM_PERSON: "Person"
        ITEM_PRICE: "Price"
        ITEM_DATE: "Date"
        ITEM_TIME: "Time"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Are you sure you want to cancel this booking?"
        ITEM_SERVICE: "Service"
        ITEM_WHEN: "When"
        PROGRESS_CANCEL_BOOKING: "Cancel booking"
        PROGRESS_CANCEL_CANCEL: "Do not cancel"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "Email"
        EMAIL_VALIDATION_REQUIRED_MESSAGE: "Please enter your email"
        EMAIL_VALIDATION_PATTERN_MESSAGE: "Please enter a valid email address"
        PASSWORD_LABEL: "Password"
        PLEASE_ENTER_PASSWORD: "Please enter your password"
        REMEMBER_ME: "Remember me"
        LOGIN: "Login"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Previous"
        PROGRESS_NEXT: "Next"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Export to calendar"
        SHORT_EXPORT_LABEL: "Export"
      }
      PRICE_FILTER: {
        ITEM_PRICE: "Price"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "Filter"
        FILTER_CATEGORY: "Category"
        FILTER_ANY: "Any"
        ITEM_SERVICE: "Service"
        FILTER_RESET: "Reset"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "All times are shown in {{time_zone_name}}."
        NO_AVAILABILITY: "{time_range_length, plural, It looks like there's no availability for the next {time_range_length} one{day} other{days}}"
        NEXT_AVAIL: "Jump to Next Available Day"
        ANY_DATE: "- Any Date -"
      }
      BASKET: {
        BASKET_TITLE: "Your basket"
        BASKET_ITEM_NO: "There are no items in the basket"
        BASKET_ITEM_ADD_INSTRUCT: "Please press the add another item button if you wish to add a product or service"
        ITEM: "Item"
        ITEM_PRICE: "Price"
        BASKET_RECIPIENT: "Recipient"
        BASKET_CERTIFICATE_PAID: "Certificate Paid"
        BASKET_GIFT_CERTIFICATES: "Gift Certificates"
        BASKET_PRICE_ORIGINAL: "Original Price"
        BASKET_BOOKING_FEE: "Booking Fee"
        BASKET_GIFT_CERTIFICATES_TOTAL: "Gift Certificates"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Value on Gift Certificate"
        BASKET_COUPON_DISCOUNT: "Coupon Discount"
        BASKET_TOTAL: "Total"
        BASKET_TOTAL_DUE_NOW: "Total Due Now"
        BASKET_WALLET: "Wallet"
        BASKET_WALLET_BALANCE: "Current Wallet Balance"
        BASKET_WALLET_BALANCE_INSUFFICIENT: "You do not currently have enough money in your wallet account. You can either pay the full amount, or top up to add more money to your wallet."
        BASKET_WALLET_REMAINDER_PART_ONE: "You will have"
        BASKET_WALLET_REMAINDER_PART_TWO: "left in your wallet after this purchase"
        BASKET_WALLET_TOP_UP: "Top Up"
        BASKET_COUPON_APPLY: "Apply a coupon"
        PROGRESS_APPLY: "Apply"
        BASKET_GIFT_CERTIFICATE_QUESTION: "Have a gift certificate?"
        BASKET_GIFT_CERTIFICATE_APPLY: "Apply a Gift Certificate"
        BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Apply another Gift Certificate"
        PROGRESS_APPLY: "Apply"
        BASKET_ITEM_ADD: "Add another item"
        BASKET_CHECKOUT: "Checkout"
        PROGRESS_BACK: "Back"
      }
      BASKET_ITEM_SUMMARY: {
        STEP_TITLE: "Summary"
        STEP_DESCRIPTION: "Please review the following information"
        DURATION_LABEL: "Duration"
        FULL_NAME_LABEL: "Full name"
        EMAIL_LABEL: "Email"
        MOBILE_LABEL: "Mobile"
        ADDRESS_LABEL: "Address"
        PRICE_LABEL: "Price"
        CONFIRM_BUTTON: "Confirm"
        BACK_BUTTON: "Back"
      }
      BASKET_WAITLIST: {
        WAITLIST_BOOKING_TITLE: "Your Waitlist booking"
        BOOKING_REFERENCE: "Booking Referenc"
        ITEM_SERVICE: "Service"
        ITEM_DATE_AND_OR_TIME: "Date/Time"
        ITEM_PRICE: "Price"
        PROGRESS_BOOK: "Book"
        BASKET_TOTAL: "Total"
        BASKET_TOTAL_DUE_NOW: "Total Due Now"
        CONFIRMATION_WAITLIST_SUBHEADER: "Thanks {{member_name}}. You have successully booked onto {{purchase_item}}."
        BASKET_TOTAL: "Total"
        BASKET_TOTAL_DUE_NOW: "Total Due Now"
        PRINT: "Print"
        PROGRESS_BACK: "Back"
      }
      ERROR_MODAL: {
        PROGRESS_OK: "OK"
      }
      MEMBER_FORM: {
        FIRST_NAME_LABEL: "First Name"
        LAST_NAME_LABEL: "Last Name"
        EMAIL_LABEL: "Email"
        PHONE_LABEL: "Phone"
        MOBILE_LABEL: "Mobile"
        SAVE_BUTTON: "Save"
      }
      BASKET_WALLET: {
        BASKET_WALLET_MAKE_PAYMENT: "Make Payment"
        BASKET_WALLET_TOP_UP: "Top Up"
        BASKET_WALLET_AMOUNT: "Amount"
        BASKET_WALLET: "Wallet"
        BASKET_WALLET_AMOUNT_MINIMUM: "Minimum top up amount must be greater than"
        PROGRESS_BACK: "Back"
      }
      DASH: {
        DASHBOARD: "Dashboard"
        DASHBOARD_TITLE: "Pick a Location/Service"
      }
      DAY: {
        AVAIL_MONTH_PREVIOUS: "Previous Month"
        AVAIL_MONTH_NEXT: "Next Month"
        PROGRESS_BACK: "Back"
        DATE_NOT_SELECTED: "You need to select a date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "Gift Certificates"
        BASKET_GIFT_CERTIFICATE_BUY: "Buy Gift Certificates"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Selected Gift Certificates"
        ITEM: "Item"
        ITEM_PRICE: "Price"
        RECIPIENT_ADD: "Add Recipient"
        RECIPIENT_NAME: "Recipient Name"
        DETAILS_EMAIL: "E-mail"
        PROGRESS_ADD: "Add"
        RECIPIENT_NAME_VALIDATION_MSG: "Please enter your name"
        RECIPIENT_EMAIL_VALIDATION_MSG: "Please enter your email"
        RECIPIENT: "Recipient"
        RECIPIENT_NAME: "Name"
        PROGRESS_BUY: "Buy"
        PROGRESS_BACK: "Back"
        CERTIFICATE_NOT_SELECTED_ALERT: 'You need to select at least one Gift Certificate to continue'
      }
      DURATION_LIST: {
        ITEM_FREE: "Free"
        PROGRESS_SELECT: "Select"
        PROGRESS_BACK: "Back"
        DURATON_NOT_SELECTED_ALERT: "You need to select a duration"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Course details"
        DETAILS_TITLE: "Your details"
        DETAILS_FIRST_NAME: "First Name"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "Please enter your first name"
        DETAILS_LAST_NAME: "Last Name"
        DETAILS_LAST_NAME_VALIDATION_MSG: "Please enter your last name"
        DETAILS_EMAIL: "Email"
        DETAILS_EMAIL_VALIDATION_MSG: "Please enter a valid email address"
        STORE_PHONE: "Phone"
        DETAILS_PHONE_MOBILE_VALIDATION_MSG: "Please enter a valid mobile number"
        DETAILS_ADDRESS: "Address"
        DETAILS_ADDRESS_VALIDATION_MSG: "Please enter your address"
        DETAILS_TOWN: "Town"
        DETAILS_COUNTY: "County"
        DETAILS_POSTCODE: "Postcode"
        INVALID_POSTCODE: "Please enter a valid postcode"
        DETAILS_VALIDATION_MSG: "This field is required"
        ATTENDEE_IS_YOU_QUESTION: "Are you the attendee?"
        ATTENDEE_USE_MY_DETAILS: "Yes, use my details"
        DETAILS_TERMS: "I agree to the terms and conditions"
        DETAILS_TERMS_VALIDATION_MSG: "Please accept the terms and conditions"
      }
      EVENT_GROUP_LIST: {
        PROGRESS_SELECT: "Select"
      }
      EVENT_LIST: {
        EVENT_LOCATION: "Event at"
        FILTER: "Filter"
        FILTER_CATEGORY: "Category"
        FILTER_ANY: "Any"
        ITEM_DATE: "Date"
        ITEM_PRICE: "Price"
        EVENT_SOLD_OUT_HIDE: "Hide Sold Out Events"
        EVENT_SOLD_OUT_SHOW: "Show Sold Out Events"
        FILTER_RESET: "Reset"
        FILTER_NONE: "Showing all events"
        FILTER_FILTERED: "Showing filtered events"
        EVENT_WORD: "Events"
        EVENT_NO: "No event found"
        EVENT_SPACE_WORD: "space"
        EVENT_LEFT_WORD: "left"
        ITEM_FROM: "From"
        PROGRESS_BOOK: "Book"
        EVENT_SOLD_OUT: "Sold out"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
      }
      MAIN: {
        POWERED_BY: "Bookings powered by"
      }
      MAIN_ACCOUNT: {
        POWERED_BY: "Bookings powered by"
      }
      MAIN_CONFIRMATION: {
        POWERED_BY: "Bookings powered by"
      }
      MAIN_EVENT: {
        POWERED_BY: "Bookings powered by"
      }
      MAIN_GIFT_CERTIFICATE: {
        POWERED_BY: "Bookings powered by"
      }
      MAIN_VIEW_BOOKING: {
        POWERED_BY: "Bookings powered by"
      }
      MAP: {
        PROGRESS_SEARCH: "Search"
        STORE_RESULT_TITLE: "{results, plural, =0{No results} one{1 result} other{# results}} for stores near {address}"
        HIDE_STORES: "Hide stores with no availability"
        SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        PROGRESS_SELECT: "Select"
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Membership Types"
        PROGRESS_SELECT: "Select"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Previous Day",
        AVAIL_DAY_NEXT: "Next Day",
        AVAIL_NO: "No Service Available",
        PROGRESS_BACK: "No Service Available"
        TIME_NOT_SELECTED_ALERT: "Please select a time slot"

      }
      SURVEY: {
        SURVEY_THANK_YOU: "Thank you for filling out the survey!",
        ITEM_SESSION: "Session",
        ITEM_DATE: "Date",
        SURVEY_WORD: "Survey",
        DETAILS_QUESTIONS: "Questions",
        SURVEY_SUBMIT: "Required",
        SURVEY_NO: "No survey questions for this session."
      }
      SERVICE_LIST: {
        ITEM_FREE: "Free",
        PROGRESS_SELECT: "Select",
        SERVICE_LIST_NO: "No services match your filter criteria.",
        PROGRESS_BACK: "Back"
      }
      RESOURCE_LIST: {
        PROGRESS_SELECT: "Select",
        PROGRESS_BACK:  "Back"
      }
      RESCHEDULE_REASONS:{
        MOVE_TITLE: "Move Appointment ",
        MOVE_REASON: "Please select a reason for moving your appointment:"
        MOVE_BUTTON: "Move Appointment"
        }
      PURCHASE: {
        CANCEL_CONFIRMATION: "Your booking has been cancelled.",
        CONFIRMATION_PURCHASE_TITLE: "Your {{ service_name }} booking",
        RECIPIENT_NAME: "Name",
        PRINT: " Print",
        DETAILS_EMAIL: "E-mail",
        ITEM_SERVICE: "Service",
        ITEM_WHEN: "When",
        ITEM_PRICE: "Price",
        PROGRESS_CANCEL_BOOKING: "Cancel booking",
        PROGRESS_MOVE_BOOKING: "Move booking",
        PROGRESS_BOOK_WAITLIST_ITEMS: "Book Waitlist Items"
      }
      PRINT_PURCHASE: {
        CONFIRMATION_BOOKING_TITLE: "Booking Confirmation",
        CONFIRMATION_BOOKING_SUBHEADER: "Thanks {{ member_name }}. Your booking is now confirmed. We have emailed you the details below.",
        CALENDAR_EXPORT_TITLE: "Export",
        PRINT: " Print",
        AND: "and",
        ITEM: "Item",
        ITEM_DATE: "Date",
        ITEM_QUANTITY: "Quantity",
        BOOKING_REFERENCE: "Booking Reference",
        POWERED_BY: "Bookings powered by"
      }
      PERSON_LIST: {
        PROGRESS_SELECT: "Select",
        PROGRESS_BACK: "Back"
      }
      MONTHLY_CALENDAR: {
        SELECT_DAY: "Select a day",
        WEEK_BEGINNING: "Week beginning",
        PICK_A_DATE: "Pick a date",
        PREVIOUS_5_WEEKS: "Previous 5 Weeks",
        NEXT_5_WEEKS: "Next 5 Weeks",
        KEY: "Key",
        AVAILABLE: "{number, plural, =0{No availability} other{# available}}",
        UNAVAILABLE: "Unavailable",
        PROGRESS_BACK: "Back"
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
    
