'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: "{number, plural, =0{Keine verfügbar} one{1 verfügbar} other{# verfügbare}}"
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_ALERT: "Your booking has been moved to {{datetime}}"
        MOVE_BOOKING_FAIL_ALERT: "Failed to move booking. Please try again."
      }
      ADD_RECIPIENT: {
        MODAL_HEADING: "@:COMMON.TERMINOLOGY.RECIPIENT"
        WHO_TO_QUESTION: "Who should we send the gift voucher to?"
        WHO_TO_OPTION_ME: "Me"
        WHO_TO_OPTION_NOT_ME: "Someone else"
        NAME_LBL: "Name"
        NAME_VALIDATION_MSG: "Bitte geben Sie den vollständigen Namen des Empfängers ein"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_INVALID"
        ADD_LBL: "Add Recipient"
        CANCEL_LBL: "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        STEP_HEADING: "Warenkorb Details"
        BASKET_DETAILS_NO: "Keine Artikel in den Warenkorb hinzugefügt."
        ITEM_LBL: "@:COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{ time | datetime: 'LLLL':false}} für {{ duration | time_period }}"
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
        BASKET_STATUS: "{N, plural, =0 {empty}, one {One item in your basket}, others {#items in your basket}}"
      }
      BASKET_ITEM_SUMMARY: {
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        DURATION_LBL: "@:COMMON.TERMINOLOGY.DURATION"
        RESOURCE_LBL: "@:COMMON.TERMINOLOGY.RESOURCE"
        PERSON_LBL: "@:COMMON.TERMINOLOGY.PERSON"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LBL: "@:COMMON.TERMINOLOGY.TIME"
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
        CANCEL_QUESTION: "Sind Sie sicher, Sie wollen diesen Buchung stornieren?"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LBL: "@:COMMON.TERMINOLOGY.WHEN"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        DONT_CANCEL_BOOKING_BTN: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Rezension"
        DETAILS_HEADING: "Your details"
        FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.FIRST_NAME_REQUIRED"
        LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.LAST_NAME_REQUIRED"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_REQUIRED"
        MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        ITEM_DETAILS: {
          BOOKING_QUESTIONS_HEADING: "Other information"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
          REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        }
        PROGRESS_CONFIRM: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CHECKOUT: {
        PAYMENT_WORD: "Zahlung"
        PAYMENT_DETAILS_HEADING: "Einzelheiten zur Bezahlung"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CHECKOUT_EVENT: {
        EVENT_PAYMENT: "Bitte füllen Sie die Zahlung an Ihre Buchung zu bestätigen"
        EVENT_TICKETS: "@:COMMON.TERMINOLOGY.TICKETS"
        ITEM_TYPE: "Art"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Menge"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_HEADING: "Your details"
        CLIENT_DETAILS_HEADING: "Kundendaten"
        REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.FIRST_NAME_REQUIRED"
        LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.LAST_NAME_REQUIRED"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_INVALID"
        MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE"
        BOOKING_QUESTIONS_HEADING: "Sonstige Angaben"
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
        TITLE: "Buchungsbestätigung"
        BOOKING_CONFIRMATION: "Danke {{member_name}}. Ihre Buchung ist jetzt bestätigt. Wir haben Ihnen die Angaben per E-Mail geschickt."
        ITEM_CONFIRMATION: "Bestätigung"
        WAITLIST_CONFIRMATION: "Thanks {{member_name}}. Your have successfully made the following bookings. We have you emailed you the details below."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LBL: "@:COMMON.TERMINOLOGY.TIME"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_REQUIRED: "@:COMMON.TERMINOLOGY.EMAIL_REQUIRED"
        EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_INVALID"
        PASSWORD_LBL: "@:COMMON.FORM.PASSWORD"
        PASSWORD_REQURIED: "Please enter your password"
        REMEMBER_ME: "Remember me"
        LOGIN: "@:COMMON.BTN.LOGIN"
      }
      MONTH_PICKER: {
        BACK_BTN: "@:COMMON.BTN.CANCEL"
        NEXT_BTN: "Nächster"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LBL: "Export to calendar"
        SHORT_EXPORT_LBL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        CATEGORY_FILTER_LBL: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "All times are shown in {{time_zone_name}}."
        NO_AVAILABILITY: "It looks like there's no availability for the next {time_range_length, plural, one{day} other{# days}}"
        NEXT_AVAIL: "Jump to Next Available Day"
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        ANY_DATE: "- Any Date -"
        MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING"
        AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON"
        EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
      }
      BASKET: {
        BASKET_HEADING: "Ihr Warenkorb"
        BASKET_ITEM_NO: "Es sind keine Artikel im Warenkorb"
        BASKET_ITEM_ADD_INSTRUCT: "Please press the add another item button if you wish to add a product or service"
        ITEM_LBL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        BASKET_RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        BASKET_CERTIFICATE_PAID: "Certicicate Bezahlt"
        BASKET_GIFT_CERTIFICATES: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_PRICE_ORIGINAL: "Neupreis"
        BASKET_BOOKING_FEE: "@:COMMON.TERMINOLOGY.BOOKING_FEE"
        BASKET_GIFT_CERTIFICATES_TOTAL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Restwert auf Geschenkgutscheine"
        BASKET_COUPON_DISCOUNT: "Coupon Rabatt"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_BALANCE: "Aktuelle Wallet Balance"
        BASKET_WALLET_BALANCE_INSUFFICIENT: "Ach nein! Sie haben derzeit nicht genügend Geld in der Brieftasche Konto. Sie können entweder den vollen Betrag, oder nach oben, um mehr Geld, um Ihre Brieftasche hinzufügen."
        BASKET_WALLET_REMAINDER_PART_ONE: "Du wirst haben"
        BASKET_WALLET_REMAINDER_PART_TWO: "in Ihrer Brieftasche nach diesem Kauf links"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_COUPON_APPLY: "Anwendung der Rabatt"
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        VOUCHER_BOX: {
          BASKET_GIFT_CERTIFICATE_QUESTION: "Haben Sie einen Gutschein?"
          BASKET_GIFT_CERTIFICATE_APPLY: "Tragen Sie einen Geschenkgutschein"
          BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Gelten Andere Geschenkgutschein"
          VOUCHER_CODE_PLACEHOLDER: "Enter a voucher code"
          APPLY_BTN: "@:COMMON.BTN.APPLY"
        }
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Fügen Sie ein anderes Element"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_SUMMARY: {
        STEP_HEADING: "Summary"
        STEP_DESCRIPTION: "Please review the following information"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.@:COMMON.TERMINOLOGY.DATE_TIME"
        DURATION_LBL: "@:COMMON.TERMINOLOGY.DURATION"
        NAME_LBL: "@:COMMON.TERMINOLOGY.NAME"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE"
        ADDRESS_LBL: "@:COMMON.FORM.ADDRESS"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        CONFIRM_BTN: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_WAITLIST: {
        WAITLIST_BOOKING_HEADING: "Ihre Warteliste Buchung"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.@:COMMON.TERMINOLOGY.DATE_TIME"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        CONFIRMATION_SUMMARY: {
          BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
          BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        }
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Danke {{ member_name }}. Sie haben successully auf gebucht {{ purchase_item }}."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        OK_BTN: "@:COMMON.BTN.OK"
      }
      MEMBER_FORM: {
        FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME"
        LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        PHONE_LBL: "@:COMMON.TERMINOLOGY.PHONE"
        MOBILE_LBL: "@:COMMON.TERMINOLOGY.MOBILE"
        SAVE_BTN: "@:COMMON.BTN.SAVE"
      }
      BASKET_WALLET: {
        BASKET_WALLET_MAKE_PAYMENT: "Zahlung"
        BASKET_WALLET_SHOW_TOP_UP_BOX: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_AMOUNT: "Menge"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_AMOUNT_MINIMUM: "Mindest nachfüllen Betrag muss größer sein als"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      DASH: {
        DASHBOARD: "Armaturenbrett"
        DASHBOARD_HEADING: "Wählen Sie einen Ort / @:COMMON.TERMINOLOGY.SERVICE"
      }
      DAY: {
        PREV_MONTH_BTN: "Vorheriger Monat"
        NEXT_MONTH_BTN: "Nächster Monat"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "You need to select a date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BUY_GIFT_CERT_BTN: "Kaufen Geschenkgutscheine"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Ausgewählte Geschenkgutscheine"
        ITEM_LBL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        FORM: {
          RECIPIENT_ADD: "Fügen Sie einen Empfänger"
          RECIPIENT_NAME: "Recipient Name"
          EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
          PROGRESS_ADD: "Hinzufügen"
          RECIPIENT_NAME_REQUIRED: "Bitte geben Sie den vollständigen Namen des Empfängers ein"
          RECIPIENT_EMAIL_REQUIRED: "@:COMMON.TERMINOLOGY.EMAIL_REQUIRED"
        }
        RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME: "Name"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        PROGRESS_BUY: "Kaufen"
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
        EVENT_DETAILS_HEADING: "Event-Details"
        ITEM_TYPE: "Type"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
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
        DETAILS_HEADING: "Angaben zu Ihrer Person"
        FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.FIRST_NAME_REQUIRED"
        LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.LAST_NAME_REQUIRED"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_INVALID"
        STORE_PHONE: "@:COMMON.TERMINOLOGY.PHONE"
        MOBILE_REQ_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.MOBILE_REQUIRED"
        ADDRESS_LBL: "@:COMMON.TERMINOLOGY.ADDRESS1"
        ADDRESS_REQ_VALIDATION_MSG: "@:COMMON.TERMINOLOGY.MOBILE_REQUIRED"
        ADDRESS_3_LBL: "@:COMMON.TERMINOLOGY.ADDRESS3"
        ADDRESS_4_LBL: "@:COMMON.TERMINOLOGY.ADDRESS4"
        POSTCODE_LBL: "@:COMMON.TERMINOLOGY.POSTCODE"
        POSTCODE_INVALID: "@:COMMON.TERMINOLOGY.POSTCODE_PATTERN"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        UIB_ACCORDION: {
          TICKET_WORD: "Ticket"
          DETAILS_WORD: "details"
          ATTENDEE_IS_YOU_QUESTION: "Sind Sie der Teilnehmer?"
          ATTENDEE_USE_MY_DETAILS: " Ja, verwenden Sie meine Daten"
          FIRST_NAME_LBL: "@:COMMON.TERMINOLOGY.FIRST_NAME"
          LAST_NAME_LBL: "@:COMMON.TERMINOLOGY.LAST_NAME"
          EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
          EMAIL_INVALID: "@:COMMON.TERMINOLOGY.EMAIL_INVALID"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        }
        T_AND_C_LBL: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
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
        TITLE: "Events an"
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        CATEGORY_FILTER_LBL: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY_CATEGORY: "@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        FILTER_ANY_PRICE: '@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.PRICE'
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        HIDE_FULLY_BOOKED_EVENTS: "Ausblenden Ausverkauft Events"
        SHOW_FULLY_BOOKED_EVENTS: "Ausverkauft Events anzeigen"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Zeige alle Veranstaltungen"
        FILTER_FILTERED: "Zeige gefilterte Ereignisse"
        EVENT_WORD: "@:COMMON.TERMINOLOGY.EVENTS"
        EVENT_NO: "Keine Termine gefunden"
        EVENT_SPACE_WORD: "raum"
        EVENT_LEFT_WORD: "übrig"
        PRICE_FROM: "Von"
        BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK_EVENT" 
        BACK_BTN: "@:COMMON.BTN.BACK"
        EVENT_SOLD_OUT: "Ausverkauft"
        EVENT_JOIN_WAITLIST: "Beitreten Warteliste"
      }
      MAIN: {
        POWERED_BY: "Buchungen bereitgestellt von"
      }
      MAP: {
        SEARCH_BTN: "Suche"
        SEARCH_BTN: "Suche"
        INPUT_PLACEHOLDER: "Ort, Postleitzahl oder ladens eingeben"
        GEOLOCATE_HEADING: "Aktuellen Standort benutzen"
        STORE_RESULT_HEADING: "{results, plural, =0{Keine Ergebnisse} one{1 Ergebnis} other{# Ergebnisse}} für Ausstellungsräume in der Nähe von {address}"
        HIDE_STORES: "Hide stores with no availability"
        SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        UIB_ACCORDION: {
          SELECT_BTN: "@:COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Sorry, but {{name}} is not available at this location"
        }
      }
      MEMBERSHIP_LEVELS: {
        STEP_HEADING: "Mitgliedschaftstypen"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
      }
      TIME: {
        PREV_DAY_BTN: "Vorheriger Tag"
        NEXT_DAY_BTN: "Nächster Tag"
        NO_AVAILABILITY: "Kein @:COMMON.TERMINOLOGY.SERVICE vorhanden"
        BACK_BTN: "@:COMMON.BTN.BACK"
        TIME_NOT_SELECTED_ALERT: "Please select a time slot"
        AVAIL_MORNING: "Morgens"
        AVAIL_AFTERNOON: "Nachmittags"
        AVAIL_EVENING: "Abends"
      }
      SURVEY: {
        SURVEY_THANK_YOU: "Vielen Dank für das Ausfüllen der Umfrage!"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SESSION"
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        SURVEY_QUESTIONS_HEADING: "Umfrage"
        DETAILS_QUESTIONS: "@:COMMON.TERMINOLOGY.QUESTIONS"
        SUBMIT_SURVEY_BTN: "@:COMMON.BTN.SUBMIT"
        NO_QUESTIONS: "Keine Umfrage Fragen für diese Sitzung."
      }
      SERVICE_LIST: {
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "Keine Dienste Ihren Filterkriterien."
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESCHEDULE_REASONS:{
        MOVE_HEADING: "Move Appointment"
        MOVE_REASON: "Please select a reason for moving your appointment:"
        MOVE_BTN: "Move Appointment"
        }
      PURCHASE: {
        CANCEL_CONFIRMATION_HEADING: "Ihre Buchung storniert wurde."
        HEADING: "Ihre {{ service_name }} reservierung"
        RECIPIENT_NAME: "Name"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        EMAIL_LBL: "@:COMMON.TERMINOLOGY.EMAIL"
        SERVICE_LBL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LBL: "@:COMMON.TERMINOLOGY.WHEN"
        PRICE_LBL: "@:COMMON.TERMINOLOGY.PRICE"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        MOVE_BOOKING_BTN: "Verschieben Buchung"
        BOOK_WAITLIST_ITEMS_BTN: "Buchen Warteliste Artikel"
      }
      PRINT_PURCHASE: {
        TITLE: "Buchungsbestätigung"
        BOOKING_CONFIRMATION: "Danke {{member_name}}. Ihre Buchung ist jetzt bestätigt. Wir haben Ihnen die Angaben per E-Mail geschickt."
        EXPORT_BOOKING_BTN: "@:COMMON.TERMINOLOGY.EXPORT"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        AND: "@:COMMON.TERMINOLOGY.AND"
        ITEM_LBL: "@:COMMON.TERMINOLOGY.ITEM"
        DATE_LBL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LBL: "@:COMMON.TERMINOLOGY.TIME"
        QTY_LBL: "Menge"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        POWERED_BY: "Buchungen bereitgestellt von"
      }
      PERSON_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN:   "@:COMMON.BTN.BACK"
      }
      DAY: {
        STEP_HEADING:       "Select a day"
        WEEK_BEGINNING_LBL:   "Week beginning"
        SELECT_DATE_BTN_HEADING:      "Wählen Sie ein Datum"
        PREVIOUS_5_WEEKS_BTN: "Previous 5 Weeks"
        NEXT_5_WEEKS_BTN:     "Next 5 Weeks"
        KEY:              "Key"
        AVAILABLE:        "{number, plural, =0{Keine verfügbar} one{1 verfügbar} other{# verfügbare}}"
        UNAVAILABLE:      "@:COMMON.TERMINOLOGY.UNAVAILABLE"
        BACK_BTN:    "@:COMMON.BTN.BACK"
      }
    }
  }

  $translateProvider.translations('de', translations)

  return
