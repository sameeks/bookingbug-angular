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
        EMPTY_BASKET_FOR_CHECKOUT: "You need to add some items to the basket before you can checkout."
        FB_LOGIN_NOT_A_MEMBER: "Sorry, we couldn't find a login associated with this Facebook account. You will need to sign up using Facebook first"
        FORM_INVALID: "Please complete all required fields"
        GENERIC: "Sorry, it appears that something went wrong. Please try again or call the business you're booking with if the problem persists."
        GEOLOCATION_ERROR: "Sorry, we could not determine your location. Please try searching instead."
        GIFT_CERTIFICATE_REQUIRED: "A valid Gift Certificate is required to proceed with this booking"
        INVALID_POSTCODE: "Please enter a valid postcode"
        ITEM_NO_LONGER_AVAILABLE: "Sorry. The item you were trying to book is no longer available. Please try again."
        NO_WAITLIST_SPACES_LEFT: "Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available"
        LOCATION_NOT_FOUND: "Sorry, we don't recognise that location"
        LOGIN_FAILED: "Sorry, your email or password was not recognised. Please try again or reset your password."
        SSO_LOGIN_FAILED: "Something went wrong when trying to log you in. Please try again."
        MAXIMUM_TICKETS: "Sorry, the maximum number of tickets per person has been reached."
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
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_MSG: "Your booking has been moved to {{datetime | datetime: 'LLLL'}}"
        MOVE_BOOKING_FAIL_MSG: "Failed to move booking. Please try again."
      }
      ADD_RECIPIENT: {
        MODAL_TITLE: "Recipient"
        WHO_TO_QUESTION: "Who should we send the gift voucher to?"
        WHO_TO_OPTION_ME: "Me"
        WHO_TO_OPTION_NOT_ME: "Someone else"
        NAME_LABEL: "Name"
        NAME_VALIDATION_MSG: "Please enter the recipient's full name"
        EMAIL_LABEL: "Email"
        EMAIL_VALIDATION_MSG: "Please enter a valid email address"
        ADD_LABEL: "Add Recipient"
        CANCEL_LABEL: "Cancel"

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
      }
      DURATION_LIST: {
        ITEM_FREE: "Free"
        PROGRESS_SELECT: "Select"
        PROGRESS_BACK: "Back"
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
    }
  }

  $translateProvider.translations('en', translations)

  return
