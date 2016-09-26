'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      MODAL: {
        CANCEL_BOOKING: {
          HEADER: 'Cancel'
          QUESTION: 'Are you sure you want to cancel this {{type}}?'
          APPOINTMENT_QUESTION: 'Are you sure you want to cancel this appointment?'
        }
      }
    }
    COMMON: {
      BTN: {
        CANCEL: 'Cancel'
        CLOSE: 'Close'
        NO: 'No'
        OK: 'OK'
        YES: 'Yes'
      }
      LANGUAGE: {
        EN: 'English'
        FR: 'Français'
      }

    }
  }

  $translateProvider.translations('en', translations)

  return
