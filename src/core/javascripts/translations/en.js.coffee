'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_TITLE: 'Error'
      }
      MODAL: {
        CANCEL_BOOKING: {
          HEADER: 'Cancel'
          QUESTION: 'Are you sure you want to cancel this {{type}}?'
          APPOINTMENT_QUESTION: 'Are you sure you want to cancel this appointment?'
        }
        SCHEMA_FORM: {
          OK_BTN: 'Ok'
          CANCEL_BTN: 'Cancel'
        }
      }
      FILTERS: {
        DISTANCE: {
          UNIT: 'mi'
        }
        CURRENCY: {
          THOUSANDS_SEPARATOR: ',' 
          DECIMAL_SEPARATOR: '.'
          CURRENCY_FORMAT: '%s%v'
        }
        PRETTY_PRICE: {
          FREE: 'Free'
        }
        TIME_PERIOD: {
          TIME_SEPARATOR: " and "
        }
      }
      EVENT: {
        SPACES_LEFT: 'Only {N, plural, one{one space}, others{# spaces}} left'
        JOIN_WAITLIST: 'Join waitlist'
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
