'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: "{SLOTS_NUMBER, plural, =0{no time} =1{1 time} other{{SLOTS_NUMBER} times}} available"
      }
      ALERTS: {
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
        INVALID_POSTCODE: "@:COMMON.FORM.POSTCODE_PATTERN"
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
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_ALERT: "Your booking has been moved to {{datetime | datetime: 'LLLL'}}"
        MOVE_BOOKING_FAIL_ALERT: "Failed to move booking. Please try again."
      }
      ADD_RECIPIENT: {
        MODAL_TITLE: "@:COMMON.TERMINOLOGY.RECIPIENT"
        WHO_TO_QUESTION: "Who should we send the gift voucher to?"
        WHO_TO_OPTION_ME: "Me"
        WHO_TO_OPTION_NOT_ME: "Someone else"
        NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        NAME_VALIDATION_MSG: "Please enter the recipient's full name"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        ADD_LABEL: "Add Recipient"
        CANCEL_LABEL: "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        BASKET_DETAILS_TITLE: "Basket Details"
        BASKET_DETAILS_NO: "No items added to basket yet."
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{time | datetime: 'LLLL'}} for {{duration | time_period}}"
        PROGRESS_CANCEL: "@:COMMON.BTN.CANCEL"
        BASKET_CHECKOUT: "@:COMMON.BTN.CHECKOUT"
        BASKET_STATUS: "{N, plural, =0 {empty}, one {One item in your basket}, others {#items in your basket}}"
      }
      BASKET_ITEM_SUMMARY: {
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DURATION: "@:COMMON.TERMINOLOGY.DURATION"
        ITEM_RESOURCE: "@:COMMON.TERMINOLOGY.RESOURCE"
        ITEM_PERSON: "@:COMMON.TERMINOLOGY.PERSON"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        PROGRESS_NEXT: "@:COMMON.BTN.NEXT"
        PROGRESS_MOVE_BOOKING: "@:CORE.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CATEGORY : {
        APPOINTMENT_TYPE: "Select appointment type"
        PROGRESS_BOOK: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Estás seguro que deseas cancelar tu cita"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:COMMON.TERMINOLOGY.WHEN"
        PROGRESS_CANCEL_BOOKING: "@:COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_CANCEL_CANCEL: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Revisar Cita"
        DETAILS_TITLE: "Tus detalles"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_REQUIRED"
        DETAILS_PHONE_MOBILE: "@:COMMON.FORM.MOBILE"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        ITEM_DETAILS: {
          DETAILS_OTHER_INFO: "Other information"
          DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
          REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        }
        NEXT_BTN: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CHECKOUT: {
        PAYMENT_WORD: "Payment"
        PAYMENT_DETAILS_TITLE: "Payment Details"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CHECKOUT_EVENT: {
        EVENT_PAYMENT: "Please complete payment to confirm your booking"
        EVENT_TICKETS: "@:COMMON.TERMINOLOGY.TICKETS"
        ITEM_TYPE: "Type"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_TITLE: "Tus detalles"
        CLIENT_DETAILS_TITLE: "Client details"
        REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        DETAILS_PHONE_MOBILE: "@:COMMON.FORM.MOBILE"
        DETAILS_OTHER_INFO: "Otra información"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONTINUE: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        PROGRESS_CLEAR: "@:COMMON.BTN.CLEAR"
      }
      COMPANY_CARDS: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      COMPANY_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        CONFIRMATION_BOOKING_TITLE: "Confirmación de cita"
        CONFIRMATION_BOOKING_SUBHEADER: "Gracias {{name}}, tu cita ha sido confirmada. Hemos enviado los detalles vía correo electrónico"
        ITEM_CONFIRMATION: "Confirmación"
        CONFIRMATION_BOOKING_SUBHEADER_WITH_WAITLIST: "Gracias {{name}}, las citas fueron calendarizadas exitosamente. Hemos enviado los detalles vía correo electrónico"
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_VALIDATION_REQUIRED_MESSAGE: "@:COMMON.FORM.EMAIL_REQUIRED"
        EMAIL_VALIDATION_PATTERN_MESSAGE: "@:COMMON.FORM.EMAIL_PATTERN"
        PASSWORD_LABEL: "@:COMMON.FORM.PASSWORD"
        PLEASE_ENTER_PASSWORD: "Please enter your password"
        REMEMBER_ME: "Remember me"
        LOGIN: "@:COMMON.FORM.LOGIN"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Anterior"
        PROGRESS_NEXT: "Siguiente"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Export to calendar"
        SHORT_EXPORT_LABEL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "All times are shown in {{time_zone_name}}."
        NO_AVAILABILITY: "It looks like there's no availability for the next {time_range_length, plural, one{day} other{# days}}"
        NEXT_AVAIL: "Jump to Next Available Day"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        ANY_DATE: "- Any Date -"
        MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING"
        AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON"
        EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
      }
      BASKET: {
        BASKET_TITLE: "Your basket"
        BASKET_ITEM_NO: "There are no items in the basket"
        BASKET_ITEM_ADD_INSTRUCT: "Please press the add another item button if you wish to add a product or service"
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        BASKET_RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        BASKET_CERTIFICATE_PAID: "Certificate Paid"
        BASKET_GIFT_CERTIFICATES: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_PRICE_ORIGINAL: "Original Price"
        BASKET_BOOKING_FEE: "@:COMMON.TERMINOLOGY.BOOKING_FEE"
        BASKET_GIFT_CERTIFICATES_TOTAL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Value on Gift Certificate"
        BASKET_COUPON_DISCOUNT: "Coupon Discount"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_BALANCE: "Current Wallet Balance"
        BASKET_WALLET_BALANCE_INSUFFICIENT: "You do not currently have enough money in your wallet account. You can either pay the full amount, or top up to add more money to your wallet."
        BASKET_WALLET_REMAINDER_PART_ONE: "You will have"
        BASKET_WALLET_REMAINDER_PART_TWO: "left in your wallet after this purchase"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_COUPON_APPLY: "Apply a coupon"
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        VOUCHER_BOX: {
          BASKET_GIFT_CERTIFICATE_QUESTION: "Have a gift certificate?"
          BASKET_GIFT_CERTIFICATE_APPLY: "Apply a Gift Certificate"
          BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Apply another Gift Certificate"
          VOUCHER_CODE_PLACEHOLDER: "Enter a voucher code"
          APPLY_BTN: "@:COMMON.BTN.APPLY"
        }
        PROGRESS_CANCEL: "@:COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Add another item"
        BASKET_CHECKOUT: "@:COMMON.BTN.CHECKOUT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_SUMMARY: {
        STEP_TITLE: "Summary"
        STEP_DESCRIPTION: "Please review the following information"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        FULL_NAME_LABEL: "@:COMMON.FORM.FULL_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        CONFIRM_BTN: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_WAITLIST: {
        WAITLIST_BOOKING_TITLE: "Your Waitlist booking"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        PROGRESS_BOOK: "@:COMMON.BTN.BOOK"
        CONFIRMATION_SUMMARY: {
          BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
          BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        }
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Thanks {{member_name}}. You have successully booked onto {{purchase_item}}."
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        PROGRESS_OK: "@:COMMON.BTN.OK"
      }
      MEMBER_FORM: {
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        PHONE_LABEL: "@:COMMON.FORM.PHONE"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        SAVE_BTN: "@:COMMON.BTN.SAVE"
      }
      BASKET_WALLET: {
        BASKET_WALLET_MAKE_PAYMENT: "Make Payment"
        BASKET_WALLET_SHOW_TOP_UP_BOX: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_AMOUNT: "Amount"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_AMOUNT_MINIMUM: "Minimum top up amount must be greater than"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      DASH: {
        DASHBOARD: "Dashboard"
        DASHBOARD_TITLE: "Pick a Location/@:COMMON.TERMINOLOGY.SERVICE"
      }
      DAY: {
        AVAIL_MONTH_PREVIOUS: "Previous Month"
        AVAIL_MONTH_NEXT: "Next Month"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "You need to select a date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_GIFT_CERTIFICATE_BUY: "Buy Gift Certificates"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Selected Gift Certificates"
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        FORM: {
          RECIPIENT_ADD: "Add Recipient"
          RECIPIENT_NAME: "Recipient Name"
          DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
          PROGRESS_ADD: "Add"
          RECIPIENT_NAME_VALIDATION_MSG: "Please enter your name"
          RECIPIENT_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_REQUIRED"
        }
        RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        PROGRESS_BUY: "Buy"
        BACK_BTN: "@:COMMON.BTN.BACK"
        CERTIFICATE_NOT_SELECTED_ALERT: "You need to select at least one Gift Certificate to continue"
      }
      DURATION_LIST: {
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DURATON_NOT_SELECTED_ALERT: "You need to select a duration"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Course details"
        ITEM_TYPE: "Type"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        EVENT_SOLD_OUT: "Sold Out"
        ADD_ONS: "Add-ons"
        SUBTOTAL: "Subtotal"
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATE"
        BASKET_DISCOUNT: "Discount"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_DUE_TOTAL: "Due Total"
        BASKET_GIFT_CERTIFICATE_QUESTION: "Have a gift certificate?"
        BASKET_GIFT_CERTIFICATE_APPLY: "Apply a gift Certificate"
        GIFT_CERTIFICATE_CODE_PLACEHOLDER: "Enter your certificate code"
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        BASKET_GIFT_CERTIFICATES_APPLIED: "Gift Certificates applied"
        BASKET_REMOVE_DEAL: "Remove"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Gift Certificate balance"
        DETAILS_TITLE: "Your details"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        STORE_PHONE: "@:COMMON.FORM.PHONE"
        DETAILS_PHONE_MOBILE_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        DETAILS_ADDRESS: "@:COMMON.FORM.ADDRESS"
        DETAILS_ADDRESS_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        DETAILS_TOWN: "@:COMMON.FORM.ADDRESS3"
        DETAILS_COUNTY: "@:COMMON.FORM.ADDRESS4"
        DETAILS_POSTCODE: "@:COMMON.FORM.POSTCODE"
        INVALID_POSTCODE: "@:COMMON.FORM.POSTCODE_PATTERN"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        UIB_ACCORDION: {
          TICKET_WORD: "Ticket"
          DETAILS_WORD: "details"
          ATTENDEE_IS_YOU_QUESTION: "Are you the attendee?"
          ATTENDEE_USE_MY_DETAILS: "Yes, use my details"
          DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
          DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
          DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
          DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
          DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        }
        DETAILS_TERMS: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
        DETAILS_TERMS_VALIDATION_MSG: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED"
        TICKET_WORD: "Ticket"
        DETAILS_WORD: "details"
        RESERVE_TICKET: "Reserve Ticket"
        LETTER_S: "s"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
        BOOK_TICKET: "@:COMMON.BTN.BOOK Ticket"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      EVENT_GROUP_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        EVENT_LOCATION: "Event at"
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY_CATEGORY: "@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        FILTER_ANY_PRICE: '@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.PRICE'
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        EVENT_SOLD_OUT_HIDE: "Hide Sold Out Events"
        EVENT_SOLD_OUT_SHOW: "Show Sold Out Events"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Showing all events"
        FILTER_FILTERED: "Showing filtered events"
        EVENT_WORD: "@:COMMON.TERMINOLOGY.EVENTS"
        EVENT_NO: "No event found"
        EVENT_SPACE_WORD: "space"
        EVENT_LEFT_WORD: "left"
        ITEM_FROM: "From"
        BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK @:COMMON.TERMINOLOGY.EVENT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        EVENT_SOLD_OUT: "Sold out"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
      }
      MAIN: {
        POWERED_BY: "Bookings powered by"
      }
      MAP: {
        PROGRESS_SEARCH: "Buscar"
        SEARCH_BTN_TITLE: "Buscar"
        INPUT_PLACEHOLDER: "Ingresa una ciudad o código postal"
        GEOLOCATE_TITLE: "Use current location"
        STORE_RESULT_TITLE: "{results, plural, =0{No results} one{1 result} other{# results}} for stores near {address}"
        HIDE_STORES: "Hide stores with no availability"
        SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        UIB_ACCORDION: {
          PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        }
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Membership Types"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Previous Day"
        AVAIL_DAY_NEXT: "Next Day"
        AVAIL_NO: "No @:COMMON.TERMINOLOGY.SERVICE Available"
        BACK_BTN: "@:COMMON.BTN.BACK"
        TIME_NOT_SELECTED_ALERT: "Please select a time slot"
        AVAIL_MORNING: "Mañana"
        AVAIL_AFTERNOON: "Tarde"
        AVAIL_EVENING: "Noche"
      }
      SURVEY: {
        SURVEY_THANK_YOU: "Thank you for filling out the survey!"
        ITEM_SESSION: "@:COMMON.TERMINOLOGY.SESSION"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        SURVEY_WORD: "Survey"
        DETAILS_QUESTIONS: "@:COMMON.TERMINOLOGY.QUESTIONS"
        SURVEY_SUBMIT: "@:COMMON.BTN.SUBMIT"
        SURVEY_NO: "No survey questions for this session."
      }
      SERVICE_LIST: {
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "No services match your filter criteria."
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESCHEDULE_REASONS:{
        MOVE_TITLE: "Move Appointment"
        MOVE_REASON: "Please select a reason for moving your appointment:"
        MOVE_BTN: "Move Appointment"
        }
      PURCHASE: {
        CANCEL_CONFIRMATION: "Tu cita ha sido cancelada."
        CONFIRMATION_PURCHASE_TITLE: "Your {{ service_name }} booking"
        RECIPIENT_NAME: "@:COMMON.FORM.FIRST_NAME"
        PRINT: " @:COMMON.TERMINOLOGY.PRINT"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:COMMON.TERMINOLOGY.WHEN"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        PROGRESS_CANCEL_BOOKING: "@:COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_MOVE_BOOKING: "Move booking"
        PROGRESS_BOOK_WAITLIST_ITEMS: "Book Waitlist Items"
      }
      PRINT_PURCHASE: {
        CONFIRMATION_BOOKING_TITLE: "Booking Confirmation"
        CONFIRMATION_BOOKING_SUBHEADER: "Thanks {{ member_name }}. Your booking is now confirmed. We have emailed you the details below."
        CALENDAR_EXPORT_TITLE: "@:COMMON.TERMINOLOGY.EXPORT"
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        AND: "@:COMMON.TERMINOLOGY.AND"
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
        ITEM_QUANTITY: "Quantity"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        POWERED_BY: "Bookings powered by"
      }
      PERSON_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN:   "@:COMMON.BTN.BACK"
      }
      MONTHLY_CALENDAR: {
        SELECT_DAY:       "Select a day"
        WEEK_BEGINNING:   "Week beginning"
        PICK_A_DATE:      "Pick a date"
        PREVIOUS_5_WEEKS: "Previous 5 Weeks"
        NEXT_5_WEEKS:     "Next 5 Weeks"
        KEY:              "Key"
        AVAILABLE:        "Disponible"
        UNAVAILABLE:      "@:COMMON.TERMINOLOGY.UNAVAILABLE"
        BACK_BTN:    "@:COMMON.BTN.BACK"
      }
    }
  }

  $translateProvider.translations('es', translations)

  return
