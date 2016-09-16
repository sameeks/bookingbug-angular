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
        TIME_AND_DURATION: "{{time | datetime: 'LLLL':false}} for {{duration | time_period }}"
        PROGRESS_CANCEL: "Cancel"
        BASKET_CHECKOUT: "Checkout"
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
        ANY_DATE: "\- Any Date \-"
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
    }
  }

  $translateProvider.translations('en', translations)

  return
