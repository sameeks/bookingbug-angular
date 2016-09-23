'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_TITLE: "Error"
      }
      MODAL: {
        CANCEL_BOOKING: {
          HEADER:               "Cancel"
          QUESTION:             "Are you sure you want to cancel this {{type}}?"
          APPOINTMENT_QUESTION: "Are you sure you want to cancel this appointment?"
        }
        SCHEMA_FORM: {
          OK_BTN:     "@:CORE.COMMON.BTN.OK"
          CANCEL_BTN: "@:CORE.COMMON.BTN.CANCEL"
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
          FREE: "@:CORE.COMMON.TERMINOLOGY.PRICE_FREE"
        }
        TIME_PERIOD: {
          TIME_SEPARATOR: " and "
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
        ITEM:              "Item"
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
      }
      FORM: {
        FIRST_NAME:                    "Nombre"
        FIRST_NAME_REQUIRED:           "Por favor ingresa tu nombre"
        LAST_NAME:                     "Apellido"
        LAST_NAME_REQUIRED:            "Por favor ingresa tu apellido"
        FULL_NAME:                     "Full Name"
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
        EMAIL_PATTERN:                 "Por favor ingresa una dirección de correo electrónico válida"
        FIELD_REQUIRED:                "Este campo es requerido"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Please enter your password"
        REQUIRED_LABEL:                "*Requeridos"
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
        FR: "Français"
      }

    }
  }

  $translateProvider.translations('es', translations)

  return
