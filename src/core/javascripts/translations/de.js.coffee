'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_HEADING: "Error"
        ACCOUNT_DISABLED: "Your account appears to be disabled. Please contact the business you're booking with if the problem persists."
        ALREADY_REGISTERED: "You have already registered with this email address. Please login or reset your password."
        APPT_AT_SAME_TIME: "Your appointment is already booked for this time"
        ATTENDEES_CHANGED: "Your booking has been successfully updated"
        EMAIL_ALREADY_REGISTERED_ADMIN: "There's already an account registered with this email. Use the search field to find the customers account."
        EMPTY_BASKET_FOR_CHECKOUT:"Es sind keine Artikel im Warenkorb zur Kasse gehen."
        FB_LOGIN_NOT_A_MEMBER: "Sorry, we couldn't find a login associated with this Facebook account. You will need to sign up using Facebook first"
        FORM_INVALID: "Bitte füllen Sie alle Felder aus"
        GENERIC:"Leider scheint es, dass etwas schief gelaufen ist. Bitte versuchen Sie es erneut oder rufen Sie das Unternehmen sind Sie bei der Buchung mit, wenn das Problem weiterhin besteht."
        GEOLOCATION_ERROR: "Leider konnten wir Dein Ort wurde nicht festzustellen. Bitte versuchen Sie statt."
        GIFT_CERTIFICATE_REQUIRED: "A valid Gift Certificate is required to proceed with this booking"
        POSTCODE_INVALID: "@:COMMON.FORM.POSTCODE_INVALID"
        ITEM_NO_LONGER_AVAILABLE: "Entschuldigung. Das Element, das Sie versuchten, zu buchen ist nicht mehr verfügbar. Bitte versuchen Sie es erneut."
        NO_WAITLIST_SPACES_LEFT: "Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available"
        LOCATION_NOT_FOUND: "Sorry, we don't recognise that location"
        LOGIN_FAILED: "Sorry, your email or password was not recognised. Please try again or reset your password."
        SSO_LOGIN_FAILED: "Something went wrong when trying to log you in. Please try again."
        MAXIMUM_TICKETS: "Sorry, the maximum number of tickets per person has been reached."
        MISSING_LOCATION: "Bitte geben Sie Ihren Standort"
        MISSING_POSTCODE: "Bitte geben Sie eine Postleitzahl ein"
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
        SPEND_AT_LEAST: "You need to spend at least {{min_spend | pretty_price}} to make a booking."
      }
      PAGINATION: {
        SUMMARY: "{{start}} - {{end}} of {{total}}"
      }
      MODAL: {
        CANCEL_BOOKING: {
          HEADER:               "Cancel"
          QUESTION:             "Are you sure you want to cancel this {{type}}?"
        }
        SCHEMA_FORM: {
          OK_BTN:     "@:COMMON.BTN.OK"
          CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        }
      }
      FILTERS: {
        DISTANCE: {
          UNIT: "mi"
        }
        CURRENCY: {
          THOUSANDS_SEPARATOR: ","
          DECIMAL_SEPARATOR:   "."
          CURRENCY_FORMAT:     "%s%v"
        }
        PRETTY_PRICE: {
          FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        }
        TIME_PERIOD: {
          TIME_PERIOD: "{hours, plural, =0{} one{1 hour} other{# hours}}{show_seperator, plural, =0{} =1{, } other{}}{minutes, plural, =0{} one{1 minute} other{# minutes}}"
        }
      }
      EVENT: {
        SPACES_LEFT:   "Only {N, plural, one{one space}, others{# spaces}} left"
        JOIN_WAITLIST: "Beitreten Warteliste"
      }
    }
    COMMON: {
      TERMINOLOGY: {
        CATEGORY:          "Kategorie"
        DURATION:          "Duration"
        RESOURCE:          "Ressource"
        PERSON:            "Person"
        SERVICE:           "Service"
        WALLET:            "Brieftasche"
        SESSION:           "Session"
        EVENT:             "Event"
        EVENTS:            'Geschehen'
        COURSE:            "Course"
        COURSES:           'Courses'
        DATE:              "Datum"
        TIME:              "Zeit"
        WHEN:              "Wann"
        GIFT_CERTIFICATE:  "Geschenkgutscheine"
        GIFT_CERTIFICATES: 'Gift Certificates'
        ITEM_LBL:              "Artikel"
        FILTER:            "Filter"
        ANY:               "Jeder"
        RESET:             "Rücksetzen"
        TOTAL:             "Gesamt"
        TOTAL_DUE_NOW:     "Insgesamt Aufgrund Now"
        BOOKING_FEE:       'Buchungsgebühr'
        PRICE:             "Preis"
        PRICE_FREE:        "Kostenlos"
        PRINT:             " Drucken"
        AND:               "und"
        APPOINTMENT:       "Ernennung"
        TICKETS:           "Tickets"
        EXPORT:            "Export"
        RECIPIENT:         "Empfänger"
        BOOKING_REF:       "Buchungsnummer"
        MORNING:           "Morgens"
        AFTERNOON:         "Nachmittags"
        EVENING:           "Abends"
        AVAILABLE:         "Available"
        UNAVAILABLE:       "Unavailable"
        CALENDAR:          "Calendar"
        QUESTIONS:         "Fragen"
        BOOKING:           "Booking"
        ADMITTANCE:        "Admittance"
      }
      FORM: {
        FIRST_NAME:                    "First Name"
        FIRST_NAME_REQUIRED:           "Please enter your first name"
        LAST_NAME:                     "Last Name"
        LAST_NAME_REQUIRED:            "Please enter your last name"
        NAME:                     "Full Name"
        ADDRESS1:                      "Address"
        ADDRESS_REQUIRED:              ""
        ADDRESS3:                      "Town"
        ADDRESS4:                      "County"
        POSTCODE:                      "Postcode"
        POSTCODE_INVALID:              "Bitte GEBEN Sie eine Gültige Postleitzahl ein"
        PHONE:                         "Phone"
        MOBILE:                        "Mobile"
        MOBILE_REQUIRED:               "Please enter a valid mobile number"
        EMAIL:                         "Email"
        EMAIL_REQURIED:                "Please enter your email"
        EMAIL_INVALID:                 "Bitte geben Sie eine gültige E-Mail-Adresse"
        FIELD_REQUIRED:                "This field is required"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Please enter your password"
        REQUIRED_LBL:                "*Erforderlich"
        TERMS_AND_CONDITIONS:          "Ich akzeptiere die Geschäftsbedingungen"
        TERMS_AND_CONDITIONS_REQUIRED: "Bitte stimmen Sie den Geschäftsbedingungen"
      }
      BTN: {
        CANCEL:                "Cancel"
        CLOSE:                 "Close"
        NO:                    "No"
        OK:                    "Ok"
        YES:                   "Yes"
        BACK:                  "Zurück"
        NEXT:                  "Nächster"
        LOGIN:                 "Login"
        CONFIRM:               "Confirm"
        SAVE:                  "Save"
        SELECT:                "Wählen"
        BOOK:                  "Buchen"
        BOOK_EVENT:            "Book Event"
        CANCEL_BOOKING:        "Reservierung stornieren"
        DO_NOT_CANCEL_BOOKING: "Stornieren Sie nicht"
        APPLY:                 "Anwenden"
        CLEAR:                 "Klar"
        PAY:                   "Pay"
        CHECKOUT:              "Kasse"
        TOP_UP:                "Top Up"
        ADD:                   "Hinzufügen"
        SUBMIT:                "Submit"
        DETAILS:               "Einzelheiten"
        MORE:                  "More"
        LESS:                  "Less"
        DELETE:                "Delete"
      }
      LANGUAGE: {
        EN: "English"
        DE: "Deutsch"
        ES: "Español"
        FR: "Français"
      }

    }
  }

  $translateProvider.translations('de', translations)

  return
