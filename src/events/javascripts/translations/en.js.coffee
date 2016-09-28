'use strict';

angular.module('BBAdminEvents').config ($translateProvider) ->
  'ngInject'

  translations = {
    EVENTS: {
      EVENT_CHAIN_TABLE: {
        NEW_EVENT_CHAIN_BTN: 'New Event Chain'
        DELETE_BTN: '@:COMMON.BTN.DELETE'
        EDIT_BTN: '@:COMMON.BTN.EDIT'
      }
      EVENT_GROUP_TABLE: {
        NEW_EVENT_GROUP: 'New Event Group'
        DELETE_BTN: '@:COMMON.BTN.DELETE'
        EDIT_BTN: '@:COMMON.BTN.EDIT'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
