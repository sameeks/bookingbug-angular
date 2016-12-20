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
        EMPTY_BASKET_FOR_CHECKOUT:"No hay ningún producto en la cesta para proceder a la caja."
        FB_LOGIN_NOT_A_MEMBER: "Sorry, we couldn't find a login associated with this Facebook account. You will need to sign up using Facebook first"
        FORM_INVALID: "Por favor completa todos los campos requeridos"
        GENERIC:"Disculpa, algo está incorrecto. Por favor, intentalo de nuevo o llama a la sucursal de interés si el problema persite. "
        GEOLOCATION_ERROR: "Disculpa, no podemos determinar esa localidad. Por favor busca una."
        GIFT_CERTIFICATE_REQUIRED: "A valid Gift Certificate is required to proceed with this booking"
        POSTCODE_INVALID: "@:COMMON.TERMINOLOGY.POSTCODE_PATTERN"
        ITEM_NO_LONGER_AVAILABLE: "Disculpa, el horario que seleccionaste no está disponible. Por favor, intentalo de nuevo."
        NO_WAITLIST_SPACES_LEFT: "Sorry, the space has now been taken, you are still in the waitlist and we will notify you if more spaces become available"
        LOCATION_NOT_FOUND: "Disculpa, no reconocemos esa localización"
        LOGIN_FAILED: "Sorry, your email or password was not recognised. Please try again or reset your password."
        SSO_LOGIN_FAILED: "Something went wrong when trying to log you in. Please try again."
        MAXIMUM_TICKETS: "Sorry, the maximum number of tickets per person has been reached."
        MISSING_LOCATION: "Por favor entre la localización (dirección)"
        MISSING_POSTCODE: "Por favor ingrese un código postal"
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
        JOIN_WAITLIST: "Join waitlist"
      }
    }
    COMMON: {
      TERMINOLOGY: {
        CATEGORY:          "Category"
        DURATION:          "Duración"
        RESOURCE:          "Resource"
        PERSON:            "Person"
        SERVICE:           "Servicio"
        WALLET:            "Wallet"
        SESSION:           "Session"
        EVENT:             "Event"
        EVENTS:            "Events"
        COURSE:            "Course"
        COURSES:           "Courses"
        DATE:              "Fecha"
        TIME:              "Horario"
        WHEN:              "Cuándo "
        GIFT_CERTIFICATE:  "Gift Certificate"
        GIFT_CERTIFICATES: "Gift Certificates"
        ITEM_LBL:              "Item"
        FILTER:            "Filter"
        ANY:               "Any"
        RESET:             "Reset"
        TOTAL:             "Total"
        TOTAL_DUE_NOW:     "Total Due Now"
        BOOKING_FEE:       "Booking Fee"
        PRICE:             "Precio"
        PRICE_FREE:        "Free"
        PRINT:             " Imprimir"
        AND:               "and"
        APPOINTMENT:       "Appointment"
        TICKETS:           "Tickets"
        EXPORT:            "Exportar"
        RECIPIENT:         "Recipient"
        BOOKING_REF:       "Booking Reference"
        MORNING:           "Mañana"
        AFTERNOON:         "Tarde"
        EVENING:           "Noche"
        AVAILABLE:         "Disponible"
        UNAVAILABLE:       "Unavailable"
        CALENDAR:          "Calendar"
        QUESTIONS:         "Questions"
        BOOKING:           "Booking"
        ADMITTANCE:        "Admittance"
      }
      FORM: {
        FIRST_NAME:                    "Nombre"
        FIRST_NAME_REQUIRED:           "Por favor ingresa tu nombre"
        LAST_NAME:                     "Apellido"
        LAST_NAME_REQUIRED:            "Por favor ingresa tu apellido"
        NAME:                     "Full Name"
        ADDRESS1:                      "Address"
        ADDRESS_REQUIRED:              ""
        ADDRESS3:                      "Town"
        ADDRESS4:                      "County"
        POSTCODE:                      "Postcode"
        POSTCODE_PATTERN:              "Por favor ingrese un código postal válido"
        PHONE:                         "Teléfono"
        MOBILE:                        "Mobile"
        MOBILE_REQUIRED:               "Please enter a valid mobile number"
        EMAIL:                         "Correo electrónico"
        EMAIL_REQURIED:                "Please enter your email"
        EMAIL_INVALID:                 "Por favor ingresa una dirección de correo electrónico válida"
        FIELD_REQUIRED:                "Este campo es requerido"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Please enter your password"
        REQUIRED_LBL:                "*Requeridos"
        TERMS_AND_CONDITIONS:          "I agree to the terms and conditions"
        TERMS_AND_CONDITIONS_REQUIRED: "Please accept the terms and conditions"
      }
      BTN: {
        CANCEL:                "Cancel"
        CLOSE:                 "Close"
        NO:                    "No"
        OK:                    "Ok"
        YES:                   "Yes"
        BACK:                  "Regresar"
        NEXT:                  "Siguiente"
        LOGIN:                 "Login"
        CONFIRM:               "Confirmar"
        SAVE:                  "Save"
        SELECT:                "Seleccionar"
        BOOK:                  "Cita"
        BOOK_EVENT:            "Book Event"
        CANCEL_BOOKING:        "Cancelar cita"
        DO_NOT_CANCEL_BOOKING: "No cancelar"
        APPLY:                 "Apply"
        CLEAR:                 "Clear"
        PAY:                   "Pay"
        CHECKOUT:              "Checkout"
        TOP_UP:                "Top Up"
        ADD:                   "Add"
        SUBMIT:                "Submit"
        DETAILS:               "Details"
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

  $translateProvider.translations('es', translations)

  return
