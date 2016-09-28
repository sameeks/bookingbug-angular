'use strict';

angular.module('BBMember').config ($translateProvider) ->
  'ngInject'

  translations = {
    MEMBER: {
      MODAL: {
        EDIT_BOOKING: {
          CANCEL_BTN: '@:COMMON.BTN.CANCEL'
        }
        LOGIN: {
          OK_BUTTON: '@:COMMON.BTN.OK'
          CANCEL_BTN: '@:COMMON.BTN.CANCEL'
        }
        DELETE_BOOKING: {
          TITLE: '@:COMMON.BTN.CANCEL_BOOKING'
          DESCRIPTION: '@:COMMON.TERMINOLOGY.BOOKING'
          WHEN: 'When'
          CANCEL_BOOKING_BTN: '@:COMMON.BTN.CANCEL_BOOKING'
          CANCEL_BTN: '@:COMMON.BTN.DO_NOT_CANCEL_BOOKING'
        }
        BOOKINGS_TABLE_CANCEL_BOOKING: {
          TITLE:                '@:COMMON.BTN.CANCEL_BOOKING'
          EMAIL_CUSTOMER_LABEL: 'Email customer?'
          CANCEL_BOOKING_BTN:   '@:COMMON.BTN.CANCEL_BOOKING'
          CANCEL_BTN:           '@:COMMON.BTN.DO_NOT_CANCEL_BOOKING'
        }
        PICK_COMPANY: {
          OK_BTN: '@:COMMON.BTN.OK'
          CANCEL_BTN: '@:COMMON.BTN.CANCEL'
        }
      }
      LOGIN: {
        EMAIL_LABEL:          '@:COMMON.FORM.EMAIL'
        EMAIL_PLACEHOLDER:    '@:COMMON.FORM.EMAIL'
        PASSWORD_LABEL:       '@:COMMON.FORM.PASSWORD'
        PASSWORD_PLACEHOLDER: '@:COMMON.FORM.PASSWORD'
        LOGIN_BTN:            '@:COMMON.BTN.LOGIN'
      }
      BOOKING_TABS: {
        UPCOMING_BOOKINGS: 'Upcoming bookings'
        PAST_BOOKINGS: 'Past bookings'
        PURCHASES: 'Purchases'
      }
      PAST_BOOKINGS: {
        NO_PAST_BOOKINGS: 'You don\'t currently have any past bookings.'
      }
      PREPAID_BOOKINGS: {
        NO_PREPAID_BOOKINGS: 'You don\'t currently have any pre-paid bookings.'
        REMAINING_BOOKINGS: '{remaining} of {total} remaining'
        PREPAID_BOOKING_DATES: 'Book By {{booking.book_by | datetime}} | Use from {{booking.use_from | datetime}} | Use by {{booking.use_by | datetime}}'
      }
      PURCHASES: {
        YOUR_PURCHASES: 'Your Purchases'
        NO_CURRENT_PURCHASES: 'You don\'t currently have any purchases'
      }
      UPCOMING_BOOKINGS: {
        NO_UPCOMING_BOOKINGS: 'You don\'t currently have any upcoming bookings.'
      }
      PICK_COMPANY: {
        PICK_COMPANY: 'Pick Company'
      }
      WALLET: {
        BALANCE: 'Balance'
        WALLET_NO_CREDIT: 'You dont have any credit in your wallet.'
        STATUS: 'Status'
        WALLET_NOT_ACTIVE: 'Your wallet is not active.'
        ACTIVATE: 'Activate'
        ACTIVE: 'Active'
        TOP_UP: '@:COMMON.BTN.TOP_UP'
        AMOUNT: 'Amount'
        MAKE_PAYMENT: 'Make Payment'
        TOP_UP_WALLET: 'Top up wallet by {{amount | currency}}'
      }
      WALLET_LOGS: {
        WALLET_TRANSACTION_HISTORY: 'Wallet Transaction History'
        ACTION: 'Action'
        AMOUNT: 'Amount'
        BALANCE: 'Balance'
        CHANGED_BY: 'Changed By'
        DATE_AND_TIME: 'Date and Time'
      }
      WALLET_PURCHASE_BANDS: {
        WALLET_PURCHASE_BAND: 'Wallet Purchase Bands'
        $X_FOR_$Y: '{{x | currency}} for {{y | currency}}'
        PROGRESS_BUY: 'Buy'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
