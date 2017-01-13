"use strict";

angular.module("BBMember").config ($translateProvider) ->
  "ngInject"

  translations = {
    MEMBER: {
      MODAL: {
        EDIT_BOOKING: {
          CANCEL_BTN : "@:COMMON.BTN.CANCEL"
          SAVE_BTN   : "@:COMMON.BTN.SAVE"
        }
        LOGIN: {
          OK_BTN     : "@:COMMON.BTN.OK"
          CANCEL_BTN : "@:COMMON.BTN.CANCEL"
        }
        DELETE_BOOKING: {
          TITLE              : "@:COMMON.BTN.CANCEL_BOOKING"
          DESCRIPTION_LBL    : "@:COMMON.TERMINOLOGY.BOOKING"
          WHEN_LBL           : "@:COMMON.TERMINOLOGY.WHEN"
          CANCEL_BOOKING_BTN : "@:COMMON.BTN.CANCEL_BOOKING"
          CANCEL_BTN         : "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
        }
        BOOKINGS_TABLE_CANCEL_BOOKING: {
          TITLE                       : "@:COMMON.BTN.CANCEL_BOOKING"
          EMAIL_CUSTOMER_CHECKBOX_LBL : "Email customer?"
          CANCEL_BOOKING_BTN          : "@:COMMON.BTN.CANCEL_BOOKING"
          CANCEL_BTN                  : "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
        }
        PICK_COMPANY: {
          OK_BTN     : "@:COMMON.BTN.OK"
          CANCEL_BTN : "@:COMMON.BTN.CANCEL"
        }
        BOOKING_PAYMENT: {
          DESCRIPTION : "Pay for your booking to confirm your place."
          TIME_RANGE  : "{{start | datetime: 'LT'}} - {{end | datetime: 'LT'}}"
          PAY_BTN     : "@:COMMON.BTN.PAY"
        }
      }
      LOGIN: {
        EMAIL_LBL            : "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_PLACEHOLDER    : "@:COMMON.TERMINOLOGY.EMAIL"
        PASSWORD_LBL         : "@:COMMON.FORM.PASSWORD"
        PASSWORD_PLACEHOLDER : "@:COMMON.FORM.PASSWORD"
        LOGIN_BTN            : "@:COMMON.BTN.LOGIN"
      }
      MEMBER_BOOKINGS_TABLE: {
        DETAILS_BTN : "@:COMMON.BTN.DETAILS"
        CANCEL_BTN  : "@:COMMON.BTN.CANCEL"
      }
      BOOKING: {
        TOGGLE_DROPDOWN_BTN : "Toggle Dropdown"
      }
      BOOKING_TABS: {
        UPCOMING_BOOKINGS_TAB_HEADING : "Upcoming bookings"
        PAST_BOOKINGS_TAB_HEADING     : "Past bookings"
        PURCHASES_TAB_HEADING         : "Purchases"
      }
      MEMBER_PAST_BOOKINGS: {
        NO_PAST_BOOKINGS : "You don't currently have any past bookings."
      }
      PAST_BOOKINGS: {
        HEADING :"Past Bookings"
      }
      PREPAID_BOOKINGS: {
        NO_PREPAID_BOOKINGS   : "You don't currently have any pre-paid bookings."
        REMAINING_BOOKINGS    : "{{remaining}} of {{total}} remaining"
        PREPAID_BOOKING_DATES : "Book By {{booking.book_by | datetime: 'L'}} | Use from {{booking.use_from | datetime: 'L'}} | Use by {{booking.use_by | datetime: 'L'}}"
      }
      PURCHASES: {
        YOUR_PURCHASES            : "Your Purchases"
        NO_CURRENT_PURCHASES      : "You don't currently have any purchases"
        PURCHASE_DATE_COL_HEADING : "Purchase Date"
        ITEMS_COL_HEADING         : "Items"
        TOTAL_PRICE_COL_HEADING   : "Total Price"
        LESS_DETAIL_BTN           : "@:COMMON.BTN.LESS"
        MORE_DETAIL_BTN           : "@:COMMON.BTN.MORE"
      }
      MEMBER_UPCOMING_BOOKINGS: {
        NO_UPCOMING_BOOKINGS : "You don't currently have any upcoming bookings."
        ON_WAITLIST_HEADING  : "On Waitlist"
        CONFIRMED_HEADING    : "Confirmed"
      }
      UPCOMING_BOOKINGS: {
        HEADING : "Upcoming Bookings"
      }
      PICK_COMPANY: {
        DESCRIPTION: "Pick Company"
      }
      WAITLIST_PAYMENT: {
        DESCRIPTION : "Pay for your booking to confirm your place."
        PAY_BTN     : "@:COMMON.BTN.PAY"
      }
      WALLET: {
        BALANCE_LBL              : "Balance:"
        WALLET_NO_CREDIT         : "You don't have any credit in your wallet."
        STATUS_LBL               : "Status:"
        STATUS_INACTIVE          : "Your wallet is not active."
        STATUS_ACTIVE            : "Active"
        ACTIVATE_BTN             : "Activate"
        TOP_UP_BTN               : "@:COMMON.BTN.TOP_UP"
        AMOUNT_LBL               : "Amount"
        PAYMENT_IFRAME_HEADING   : "Make Payment"
        TOP_UP_WALLET_BY         : "Top up wallet by {{amount | currency}}"
        MIN_TOP_UP               : "Minimum top up amount must be greater than {{min_amount | currency}}"
        TOPUP_AMOUNT_PLACEHOLDER : "Enter Top Up Amount"
      }
      WALLET_LOGS: {
        HEADING                : "Wallet Transaction History"
        ACTION_COL_HEADING     : "Action"
        AMOUNT_COL_HEADING     : "Amount"
        BALANCE_COL_HEADING    : "Balance"
        CHANGED_BY_COL_HEADING : "Changed By"
        DATE_TIME_COL_HEADING  : "@:COMMON.TERMINOLOGY.DATE_TIME"
      }
      WALLET_PURCHASE_BANDS: {
        HEADING   : "Wallet Purchase Bands"
        $X_FOR_$Y : "{{x | currency}} for {{y | currency}}"
        BUY_BTN   : "@:COMMON.BTN.BUY"
      }
      PURCHASE_HISTORY: {
        HEADING : "Purchase History"
      }
    }
  }

  $translateProvider.translations("en", translations)

  return
