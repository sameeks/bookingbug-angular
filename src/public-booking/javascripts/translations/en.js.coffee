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
        RECIPIENT:"Recipient",
        RECIPIENT_ADD:"Add a Recipient",
        EMAIL_VALIDATION_MSG:"Please enter a valid email address",
        RECIPIENT_ME:"Me",
        RECIPIENT_NAME:"Name",
        RECIPIENT_NAME_VALIDATION_MSG:"Please enter the recipient's full name",
        RECIPIENT_NOT_ME:"Someone else",
        WHO_TO:"Who should we send the gift voucher to?"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Previous Day",
        AVAIL_DAY_NEXT: "Next Day",
        AVAIL_NO: "No Service Available",
        PROGRESS_BACK: "No Service Available"
      }
      SURVEY: {
        SURVEY_THANK_YOU: "Thank you for filling out the survey!",
        ITEM_SESSION: "ITEM_SESSION":"Session",
        ITEM_DATE: "ITEM_DATE":"Date",
        SURVEY_WORD: "SURVEY_WORD":"Survey",
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
    }
  }

  $translateProvider.translations('en', translations)

  return
