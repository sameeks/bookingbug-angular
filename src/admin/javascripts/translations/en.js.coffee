"use strict";

angular.module("BBAdmin").config ($translateProvider) ->
  "ngInject"

  translations = {
    ADMIN: {
      CANCEL_BOOKING_MODAL: {
        TITLE            : "Cancel Booking"
        REASON_LBL       : "Cancel reason"
        SEND_EMAIL_LBL   : "Send cancellation confirmation to {{email}}?"
        OK_BTN           : "COMMON.BTN.OK"
        CLOSE_BTN        : "COMMON.BTN.CLOSE"
      }
      LOGIN: {
        EMAIL_LBL            : "@:COMMON.TERMINOLOGY.EMAIL"
        EMAIL_PLACEHOLDER    : "@:COMMON.TERMINOLOGY.EMAIL"
        PASSWORD_LBL         : "@:COMMON.FORM.PASSWORD"
        PASSWORD_PLACEHOLDER : "@:COMMON.FORM.PASSWORD"
        LOGIN_BTN            : "@:COMMON.BTN.LOGIN"
      }
      PICK_COMPANY : {
        STEP_SUMMARY : "Pick Company"
      }
      BOOKNG_TABLE : {
        NEW_BOOKING_BTN : "New booking"
        EDIT_BTN        : "@:COMMON.BTN.EDIT"
      }
    }
  }

  $translateProvider.translations("en", translations)

  return
