'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: '{SLOTS_NUMBER, plural, =0{0 available} =1{1 available} other{{SLOTS_NUMBER} available}}'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
