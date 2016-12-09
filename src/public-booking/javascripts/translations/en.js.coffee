'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        NUM_SLOTS_AVAILABLE: "{SLOTS_NUMBER, plural, =0{no time} =1{1 time} other{{SLOTS_NUMBER} times}} available"
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_ALERT: "Your booking has been moved to {{datetime}}"
        MOVE_BOOKING_FAIL_ALERT: "Failed to move booking. Please try again."
        SECTION_TITLE: "Your Booking"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
      }
      ADD_RECIPIENT: {
        MODAL_TITLE:          "@:COMMON.TERMINOLOGY.RECIPIENT"
        WHO_TO_QUESTION:      "Who should we send the gift voucher to?"
        WHO_TO_OPTION_ME:     "Me"
        WHO_TO_OPTION_NOT_ME: "Someone else"
        NAME_LABEL:           "Name"
        NAME_VALIDATION_MSG:  "Please enter the recipient's full name"
        EMAIL_LABEL:          "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        ADD_LABEL:            "Add Recipient"
        CANCEL_LABEL:         "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        MODAL_TITLE:    "Basket Details"
        NO_ITEMS_IN_BASKET:       "No items added to basket yet."
        ITEM_COL_HEADING:             "@:COMMON.TERMINOLOGY.ITEM"
        TIME_DURATION_COL_HEADING: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        ITEM_TIME_AND_DURATION:       "{{time | datetime: 'LLLL'}} for {{duration | time_period}}"
        CANCEL_BTN:         "@:COMMON.BTN.CANCEL"
        CHECKOUT_BTN:         "@:COMMON.BTN.CHECKOUT"
      }
      BASKET_ITEM_SUMMARY: {
        SERVICE_LABEL:  "@:COMMON.TERMINOLOGY.SERVICE"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        RESOURCE_LABEL: "@:COMMON.TERMINOLOGY.RESOURCE"
        PERSON_LABEL:   "@:COMMON.TERMINOLOGY.PERSON"
        PRICE_LABEL:    "@:COMMON.TERMINOLOGY.PRICE"
        DATE_LABEL:     "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL:     "@:COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        NEXT_BTN:         "@:COMMON.BTN.NEXT"
        MOVE_BOOKING_BTN: "@:COMMON.BTN.BOOK"
        BACK_BTN:         "@:COMMON.BTN.BACK"
      }
      CATEGORY : {
        STEP_DESCRIPTION: "Select appointment type"
        BOOK_BTN:    "@:COMMON.BTN.BOOK"
        BACK_BTN:         "@:COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        MODAL_TITLE:         "Are you sure you want to cancel this booking?"
        SERVICE_LABEL:            "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL:               "@:COMMON.TERMINOLOGY.WHEN"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        DONT_CANCEL_BOOKING_BTN:  "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        STEP_TITLE: "Review"
        NEXT_BTN: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CHECKOUT: {
        STEP_TITLE: "Payment"
        PAYMENT_DETAILS_TITLE: "Payment Details"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CHECKOUT_EVENT: {
        STEP_DESCRIPTION: "Please complete payment to confirm your booking."
        TICKETS_HEADER: "@:COMMON.TERMINOLOGY.TICKETS"
        TYPE_COL_HEADING: "Type"
        PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE"
        QTY_COL_HEADING: "Qty"
        PRICE_FREE: "Free"
        BASKET_TOTAL_LABEL: "@:COMMON.TERMINOLOGY.TOTAL"
        FOR_NUM_TICKETS: "(for {{count_as}})"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        STEP_TITLE: "Your Details"
        ADMIN_STEP_TITLE: "Customer Details"
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
        TITLE: "Confirmation"
        BOOKING_CONFIRMATION: "Thanks {{member_name}}. Your booking is now confirmed. We have emailed you the details below."
        WAITLIST_CONFIRMATION: "Thanks {{member_name}}. Your have successfully made the following bookings. We have you emailed you the details below."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        PURCHASE_REF_LABEL: "Purchase Reference"
        BOOKING_REF_LABEL: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_TIME_LABEL: "@:COMMON.TERMINOLOGY.DATE"
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
        LOGIN_BTN: "@:COMMON.BTN.LOGIN"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Previous"
        NEXT_BTN: "Next"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Export to calendar"
        SHORT_EXPORT_LABEL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER_HEADING: "@:COMMON.TERMINOLOGY.FILTER"
        CATEGORY_LABEL: "@:COMMON.TERMINOLOGY.CATEGORY"
        ANY_CATEGORY: "Any Category"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE"
        RESET_BTN: "@:COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        TIMEZONE_INFO: "All times are shown in {{time_zone_name}}."
        NO_AVAILABILITY: "It looks like there's no availability for the next {time_range_length, plural, one{day} other{# days}}"
        NEXT_AVAIL_BTN: "Jump to Next Available Day"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        ANY_DATE: "- Any Date -"
        MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING"
        AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON"
        EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
      }
      BASKET: {
        TITLE: "Your basket"
        NO_ITEMS_IN_BASKET: "There are no items in the basket"
        ADD_ITEM_INSTRUCTION: "Please press the add another item button if you wish to add a product or service"
        ITEM_COL_HEADING: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE"
        RECIPIENT_LABEL: "@:COMMON.TERMINOLOGY.RECIPIENT"
        CERTIFICATE_PAID_LABEL: "Certificate Paid"
        GIFT_CERTIFICATES_HEADING: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        ORIGINAL_PRICE_LABEL: "Original Price"
        BOOKING_FEE_LABEL: "@:COMMON.TERMINOLOGY.BOOKING_FEE"
        GIFT_CERTIFICATES_TOTAL_LABEL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        GIFT_CERTIFICATE_BALANCE_LABEL: "Remaining Value on Gift Certificate"
        COUPON_DISCOUNT_LABEL: "Coupon Discount"
        TOTAL_LABEL: "@:COMMON.TERMINOLOGY.TOTAL"
        TOTAL_DUE_NOW_LABEL: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        WALLET_HEADING: "@:COMMON.TERMINOLOGY.WALLET"
        WALLET_BALANCE_LABEL: "Current Wallet Balance"
        WALLET_BALANCE_INSUFFICIENT: "You do not currently have enough money in your wallet account. You can either pay the full amount, or top up to add more money to your wallet."
        WALLET_REMAINDER_PART_ONE: "You will have"
        WALLET_REMAINDER_PART_TWO: "left in your wallet after this purchase"
        TOP_UP_WALLET_BTN: "@:COMMON.BTN.TOP_UP"
        APPLY_COUPON_LABEL: "Apply a coupon"
        APPLY_COUPON_BTN: "@:COMMON.BTN.APPLY"
        GIFT_CERTIFICATE: {
          QUESTION: "Have a gift certificate?"
          APPLY_LABEL: "Apply a Gift Certificate"
          APPLY_ANOTHER_LABEL: "Apply another Gift Certificate"
          CODE_PLACEHOLDER: "Enter a certificate code"
          APPLY_BTN: "@:COMMON.BTN.APPLY"
        }
        ADD_ANOTHER_BTN: "Add another item"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_SUMMARY: {
        STEP_TITLE: "Summary"
        STEP_DESCRIPTION: "Please review the following information"
        DATE_TIME_LABEL: "Date/Time"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        FULL_NAME_LABEL: "@:COMMON.FORM.FULL_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        CONFIRM_BTN: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BOOK_WAITLIST: {
        STEP_TITLE: "Your Waitlist {num_bookings, plural =1{Booking} other{Bookings}}"
        BOOKING_REF_LABEL: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_TIME_LABEL: "@:COMMON.TERMINOLOGY.DATE/Time"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        TOTAL_LABEL: "@:COMMON.TERMINOLOGY.TOTAL"
        TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BOOKING_CONFIRMATION: "Thanks {{member_name}}. You have successully booked onto {{purchase_item}}."
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
        STEP_TITLE: "Make Payment"
        SHOW_TOP_UP_FORM_BTN: "@:COMMON.BTN.TOP_UP"
        TOP_UP_BTN: "Top up Wallet"
        AMOUNT_BY_LABEL: "Amount"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        MINIMUM_AMOUNT_WARNING: "Minimum top up amount must be greater than {{min_amount | currency}}"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      DASH: {
        TITLE: "Dashboard"
        DESCRIPTION: "Pick a Location/Person"
      }
      DAY: {
        PREV_MONTH_BTN: "Previous Month"
        NEXT_MONTH_BTN: "Next Month"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      DEAL_LIST: {
        TITLE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BUY_GIFT_CERT_BTN: "Buy Gift Certificates"
        SELECTED_CERTIFICATES: "Selected Gift Certificates"
        CERTIFICATE_COL_HEADING: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE"
        RECIPIENT_FORM: {
          TITLE: "Add Recipient"
          RECIPIENT_NAME_LABEL: "Recipient Name"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          ADD_RECIPIENT_BTN: "Add"
          RECIPIENT_NAME_REQUIRED: "Please enter your name"
          RECIPIENT_EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED"
        }
        RECIPIENT_HEADING: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME_LABEL: "Name"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        BUY_BTN: "Buy"
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
        EVENT_DETAILS_TITLE: "Event details"
        TICKET_TYPE_COL_HEADING: "Type"
        TICKET_PRICE_COL_HEADING: "@:COMMON.TERMINOLOGY.PRICE"
        TICKET_QTY_COL_HEADING: "Qty"
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        EVENT_SOLD_OUT: "Sold Out"
        ADD_ONS_LABEL: "Add-ons"
        SUBTOTAL_LABEL: "Subtotal"
        GIFT_CERT_LABEL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATE"
        DISCOUNT_LABEL: "Discount"
        BASKET_TOTAL_LABEL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_DUE_TOTAL_LABEL: "Due Total"
        BASKET_GIFT_CERTIFICATE_QUESTION: "Have a gift certificate?"
        BASKET_GIFT_CERTIFICATE_APPLY: "Apply a gift Certificate"
        GIFT_CERTIFICATE_CODE_PLACEHOLDER: "Enter your certificate code"
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        BASKET_GIFT_CERTIFICATES_APPLIED: "Gift Certificates applied"
        BASKET_REMOVE_DEAL: "Remove"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Gift Certificate balance"
        CUSTOMER_DETAILS_HEADING: "Your details"
        TICKET_ACCORDION: {
          TICKET_HEADING: "Ticket {num_tickets, plural, =0{details} others{{ticket_number} details}}"
          ATTENDEE_IS_YOU_QUESTION: "Are you the attendee?"
          ATTENDEE_USE_MY_DETAILS: "Yes, use my details"
          FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
          LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        }
        T_AND_C_LABEL: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
        T_AND_C_REQUIRED: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED"
        RESERVE_TICKET_BTN: "Reserve {num_tickets, plural, =0{Ticket} one{Ticket} other{Tickets}}"
        JOIN_WAITLIST_BTN: "Join Waitlist" 
        BOOK_TICKET_BTN: "Book {num_tickets, plural, =0{Ticket} one{Ticket} other{Tickets}}"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      EVENT_GROUP_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        TITLE: "Events at {{company_name}}"
        TIMEZONE_INFO: "All times are shown in {{time_zone_name}}"
        FILTER: {
          HEADING: "@:COMMON.TERMINOLOGY.FILTER"
          CATEGORY_LABEL: "@:COMMON.TERMINOLOGY.CATEGORY"
          ANY_CATEGORY_OPTION: "- Any Category -"
          ANY_OPTION: "- Any {{filter_name}} -"
          PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
          ANY_PRICE_OPTION: "- Any Price -"
          DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
          DATE_PICKER_TITLE: "Pick date"
          DATE_PICKER_PLACEHOLDER: "- Any Date -"
          HIDE_FULLY_BOOKED_EVENTS: "Hide Fully Booked Events"
          SHOW_FULLY_BOOKED_EVENTS: "Show Fully Booked Events"
          RESET_FILTER_BTN: "@:COMMON.TERMINOLOGY.RESET" 
          NO_FILTER_APPLIED: "Showing all events"
          FILTER_APPLIED: "Showing filtered events"
        }
        NO_EVENTS: "No events found"
        SPACES_LEFT: "{spaces_left, plural, =0{No spaces} one{# space} other{# spaces}} left"
        PRICE_FROM: "From {{min_ticket_price | ipretty_price}}" 
        BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK_EVENT" 
        EVENT_SOLD_OUT: "Sold out"
        JOIN_WAITLIST_BTN: "Join Waitlist"
        MORE_INFO: "More Info"
        LESS_INFO: "Less Info"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      MAIN: {
        POWERED_BY: "Bookings powered by"
      }
      MAP: {
        PROGRESS_SEARCH: "Search"
        SEARCH_BTN: "Search"
        INPUT_PLACEHOLDER: "Enter a town, city, postcode or store"
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
      LOGIN: {
        NO_ACCOUNT: "Don't have an account?"
        SIGN_UP_BTN: "Sign U"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Previous Day"
        AVAIL_DAY_NEXT: "Next Day"
        AVAIL_NO: "No @:COMMON.TERMINOLOGY.SERVICE Available"
        BACK_BTN: "@:COMMON.BTN.BACK"
        TIME_NOT_SELECTED_ALERT: "Please select a time slot"
        MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING"
        AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON"
        EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
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
        CANCEL_CONFIRMATION: "Your booking has been cancelled."
        CONFIRMATION_PURCHASE_TITLE: "Your {{ service_name }} booking"
        RECIPIENT_NAME: "Name"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
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
        AVAILABLE:        "{number, plural, =0{No availability} other{# available}}"
        UNAVAILABLE:      "@:COMMON.TERMINOLOGY.UNAVAILABLE"
        BACK_BTN:    "@:COMMON.BTN.BACK"
      }
      REGISTER: {
        
      }
      MAIN_ACCOUNT: {
        
      }
      ACCOUNT: {
        HEADING: 'My Details'
      }
      CLIENT_FORM: {
        CLIENT_DETAILS_HEADING: "Contact Information"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_REQUIRED: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_REQUIRED: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_REQUIRED"
        PASSWORD_LABEL: "@:COMMON.FORM.PASSWORD"
        PASSWORD_REQUIRED: "@:COMMON.FORM.PASSWORD_REQUIRED"
        CONFIRM_PASSWORD_LABEL: "@:COMMON.FORM.CONFIRM_PASSWORD"
        PASSWORD_MISMATCH: "@:COMMON.FORM.PASSWORD_MISMATCH"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        MOBILE_INVALID: "@:COMMON.FORM.MOBILE_PATTERN"
        PHONE_LABEL: "@:COMMON.FORM.PHONE"
        PHONE_INVALID: "@:COMMON.FORM.PHONE_PATTERN"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS1"
        ADDRESS_REQUIRED: "@:COMMON.FORM.ADDRESS_REQUIRED"
        ADDRESS_3_LABEL: "@:COMMON.FORM.ADDRESS3"
        ADDRESS_4_LABEL: "@:COMMON.FORM.ADDRESS4"
        ADDRESS_5_LABEL: "@:COMMON.FORM.ADDRESS5"
        POSTCODE_LABEL: "@:COMMON.FORM.POSTCODE"
        POSTCODE_INVALID: "@:COMMON.FORM.POSTCODE_PATTERN"
        CLIENT_QUESTIONS_HEADING: "Additional Information"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        NEXT_BTN: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }

    }
  }

  $translateProvider.translations('en', translations)

  return
