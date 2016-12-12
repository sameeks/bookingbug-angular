'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: "{SLOTS_NUMBER, plural, =0{no time} =1{1 time} other{{SLOTS_NUMBER} times}} available"
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_ALERT: "Your booking has been moved to {{datetime}}"
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
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        ADD_LABEL: "Add Recipient"
        CANCEL_LABEL: "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        STEP_TITLE: "Basket Details"
        BASKET_DETAILS_NO: "No items added to basket yet."
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{time | datetime: 'LLLL'}} for {{duration | time_period}}"
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
        BASKET_STATUS: "{N, plural, =0 {empty}, one {One item in your basket}, others {#items in your basket}}"
      }
      BASKET_ITEM_SUMMARY: {
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        RESOURCE_LABEL: "@:COMMON.TERMINOLOGY.RESOURCE"
        PERSON_LABEL: "@:COMMON.TERMINOLOGY.PERSON"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        NEXT_BTN: "@:COMMON.BTN.NEXT"
        MOVE_BOOKING_BTN: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CATEGORY : {
        APPOINTMENT_TYPE: "Select appointment type"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Estás seguro que deseas cancelar tu cita"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL: "@:COMMON.TERMINOLOGY.WHEN"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        DONT_CANCEL_BOOKING_BTN: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Revisar Cita"
        DETAILS_TITLE: "Tus detalles"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_REQUIRED"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        ITEM_DETAILS: {
          BOOKING_QUESTIONS_HEADING: "Other information"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
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
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_TITLE: "Tus detalles"
        CLIENT_DETAILS_TITLE: "Client details"
        REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        BOOKING_QUESTIONS_HEADING: "Otra información"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONTINUE: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        PROGRESS_CLEAR: "@:COMMON.BTN.CLEAR"
      }
      COMPANY_CARDS: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      COMPANY_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        TITLE: "Confirmación de cita"
        BOOKING_CONFIRMATION: "Gracias {{name}}, tu cita ha sido confirmada. Hemos enviado los detalles vía correo electrónico"
        ITEM_CONFIRMATION: "Confirmación"
        WAITLIST_CONFIRMATION: "Gracias {{name}}, las citas fueron calendarizadas exitosamente. Hemos enviado los detalles vía correo electrónico"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        PASSWORD_LABEL: "@:COMMON.FORM.PASSWORD"
        PASSWORD_REQURIED: "Please enter your password"
        REMEMBER_ME: "Remember me"
        LOGIN: "@:COMMON.BTN.LOGIN"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Anterior"
        NEXT_BTN: "Siguiente"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Export to calendar"
        SHORT_EXPORT_LABEL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        CATEGORY_FILTER_LABEL: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
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
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
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
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Add another item"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
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
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        CONFIRMATION_SUMMARY: {
          BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
          BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        }
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Thanks {{member_name}}. You have successully booked onto {{purchase_item}}."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        OK_BTN: "@:COMMON.BTN.OK"
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
        PREV_MONTH_BTN: "Previous Month"
        NEXT_MONTH_BTN: "Next Month"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "You need to select a date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BUY_GIFT_CERT_BTN: "Buy Gift Certificates"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Selected Gift Certificates"
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        FORM: {
          RECIPIENT_ADD: "Add Recipient"
          RECIPIENT_NAME: "Recipient Name"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          PROGRESS_ADD: "Add"
          RECIPIENT_NAME_REQUIRED: "Please enter your name"
          RECIPIENT_EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED"
        }
        RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME: "@:COMMON.FORM.FIRST_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        PROGRESS_BUY: "Buy"
        BACK_BTN: "@:COMMON.BTN.BACK"
        CERTIFICATE_NOT_SELECTED_ALERT: "You need to select at least one Gift Certificate to continue"
      }
      DURATION_LIST: {
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DURATON_NOT_SELECTED_ALERT: "You need to select a duration"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Course details"
        ITEM_TYPE: "Type"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
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
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        STORE_PHONE: "@:COMMON.FORM.PHONE"
        MOBILE_REQ_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS1"
        ADDRESS_REQ_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        ADDRESS_3_LABEL: "@:COMMON.FORM.ADDRESS3"
        ADDRESS_4_LABEL: "@:COMMON.FORM.ADDRESS4"
        POSTCODE_LABEL: "@:COMMON.FORM.POSTCODE"
        POSTCODE_INVALID: "@:COMMON.FORM.POSTCODE_PATTERN"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        UIB_ACCORDION: {
          TICKET_WORD: "Ticket"
          DETAILS_WORD: "details"
          ATTENDEE_IS_YOU_QUESTION: "Are you the attendee?"
          ATTENDEE_USE_MY_DETAILS: "Yes, use my details"
          FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
          LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        }
        T_AND_C_LABEL: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
        T_AND_C_REQUIRED: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED"
        TICKET_WORD: "Ticket"
        DETAILS_WORD: "details"
        RESERVE_TICKET: "Reserve Ticket"
        LETTER_S: "s"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
        BOOK_TICKET: "@:COMMON.BTN.BOOK Ticket"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      EVENT_GROUP_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        TITLE: "Event at"
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        CATEGORY_FILTER_LABEL: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY_CATEGORY: "@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        FILTER_ANY_PRICE: '@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.PRICE'
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        HIDE_FULLY_BOOKED_EVENTS: "Hide Sold Out Events"
        SHOW_FULLY_BOOKED_EVENTS: "Show Sold Out Events"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Showing all events"
        FILTER_FILTERED: "Showing filtered events"
        EVENT_WORD: "@:COMMON.TERMINOLOGY.EVENTS"
        EVENT_NO: "No event found"
        EVENT_SPACE_WORD: "space"
        EVENT_LEFT_WORD: "left"
        PRICE_FROM: "From"
        BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK_EVENT" 
        BACK_BTN: "@:COMMON.BTN.BACK"
        EVENT_SOLD_OUT: "Sold out"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
      }
      MAIN: {
        POWERED_BY: "Bookings powered by"
      }
      MAP: {
        SEARCH_BTN: "Buscar"
        SEARCH_BTN: "Buscar"
        INPUT_PLACEHOLDER: "Ingresa una ciudad o código postal"
        GEOLOCATE_TITLE: "Use current location"
        STORE_RESULT_TITLE: "{results, plural, =0{No results} one{1 result} other{# results}} for stores near {address}"
        HIDE_STORES: "Hide stores with no availability"
        SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        UIB_ACCORDION: {
          SELECT_BTN: "@:COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        }
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Membership Types"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        SURVEY_WORD: "Survey"
        DETAILS_QUESTIONS: "@:COMMON.TERMINOLOGY.QUESTIONS"
        SURVEY_SUBMIT: "@:COMMON.BTN.SUBMIT"
        SURVEY_NO: "No survey questions for this session."
      }
      SERVICE_LIST: {
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "No services match your filter criteria."
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL: "@:COMMON.TERMINOLOGY.WHEN"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        MOVE_BOOKING_BTN: "Move booking"
        BOOK_WAITLIST_ITEMS_BTN: "Book Waitlist Items"
      }
      PRINT_PURCHASE: {
        TITLE: "Booking Confirmation"
        BOOKING_CONFIRMATION: "Thanks {{ member_name }}. Your booking is now confirmed. We have emailed you the details below."
        CALENDAR_EXPORT_TITLE: "@:COMMON.TERMINOLOGY.EXPORT"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        AND: "@:COMMON.TERMINOLOGY.AND"
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
        QTY_LABEL: "Quantity"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        POWERED_BY: "Bookings powered by"
      }
      PERSON_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
