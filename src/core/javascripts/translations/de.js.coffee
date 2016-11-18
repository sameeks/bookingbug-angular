'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_TITLE: "Error"
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
        ITEM:              "Artikel"
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
        FULL_NAME:                     "Full Name"
        ADDRESS1:                      "Address"
        ADDRESS_REQUIRED:              ""
        ADDRESS3:                      "Town"
        ADDRESS4:                      "County"
        POSTCODE:                      "Postcode"
        POSTCODE_PATTERN:              "Bitte GEBEN Sie eine Gültige Postleitzahl ein"
        PHONE:                         "Phone"
        MOBILE:                        "Mobile"
        MOBILE_REQUIRED:               "Please enter a valid mobile number"
        EMAIL:                         "Email"
        EMAIL_REQURIED:                "Please enter your email"
        EMAIL_PATTERN:                 "Bitte geben Sie eine gültige E-Mail-Adresse"
        FIELD_REQUIRED:                "This field is required"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Please enter your password"
        REQUIRED_LABEL:                "*Erforderlich"
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
