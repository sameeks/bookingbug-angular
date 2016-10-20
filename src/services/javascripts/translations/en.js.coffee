'use strict';

angular.module('BBAdminServices').config ($translateProvider) ->
  'ngInject'

  translations = {
    SERVICES: {
      PERSON_TABLE: {
        NEW_PERSON: 'New Person'
        DELETE: '@:COMMON.BTN.DELETE'
        EDIT: '@:COMMON.BTN.EDIT'
        SCHEDULE: 'Schedule'
      }
      RESOURCE_TABLE: {
        NEW_RESOURCE: 'New Resource'
        DELETE: '@:COMMON.BTN.DELETE'
        EDIT: '@:COMMON.BTN.EDIT'
        SCHEDULE: 'Schedule'
      }
      SERVICE_TABLE: {
        NEW_SERVICE: 'New Service'
        EDIT: '@:COMMON.BTN.EDIT'
        PROGRESS_BOOK: '@:COMMON.BTN.BOOK'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return