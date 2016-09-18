'use strict';

angular.module('BBAdmin').config ($translateProvider) ->
  'ngInject'

  translations = {
    ADMIN: {
      MODAL: {
        CANCEL_BOOKING: {
          REASON: 'Cancel reason'
          SEND_EMAIL: 'Send cancellation confirmation to {{email}}?'
          TITLE: 'Cancel Booking'
        }
      }
      LOGIN: {
        EMAIL_LABEL          : 'Email'
        EMAIL_PLACEHOLDER    : 'Email'
        PASSWORD_LABEL       : 'Password'
        PASSWORD_PLACEHOLDER : 'Password'
        LOGIN_BTN            : 'Login'
      }
      PICK_COMPANY : {
        STEP_SUMMARY : 'Pick Company'
      }
      BOOKNG_TABLE : {
        NEW_BOOKING_BTN : 'New booking'
        EDIT_BTN        : 'Edit'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
