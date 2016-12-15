'use strict';

angular.module('BBAdmin').config ($translateProvider) ->
  'ngInject'

  translations = {
    ADMIN: {
      CANCEL_BOOKING_MODAL: {
        TITLE            : 'Cancel Booking'
        REASON_LABEL     : 'Cancel reason'
        SEND_EMAIL_LABEL : 'Send cancellation confirmation to {{email}}?'
        OK_BTN           : 'COMMON.BTN.OK'
        CLOSE_BTN        : 'COMMON.BTN.CLOSE'
      }
      LOGIN: {
        EMAIL_LABEL          : '@:COMMON.FORM.EMAIL'
        EMAIL_PLACEHOLDER    : '@:COMMON.FORM.EMAIL'
        PASSWORD_LABEL       : '@:COMMON.FORM.PASSWORD'
        PASSWORD_PLACEHOLDER : '@:COMMON.FORM.PASSWORD'
        LOGIN_BTN            : '@:COMMON.BTN.LOGIN'
      }
      PICK_COMPANY : {
        STEP_SUMMARY : 'Pick Company'
      }
      BOOKNG_TABLE : {
        NEW_BOOKING_BTN : 'New booking'
        EDIT_BTN        : '@:COMMON.BTN.EDIT'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
