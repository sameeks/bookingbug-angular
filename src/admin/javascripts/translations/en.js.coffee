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
    }
  }

  $translateProvider.translations('en', translations)

  return
