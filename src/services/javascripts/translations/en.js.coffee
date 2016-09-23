'use strict';

angular.module('BBAdminServices').config ($translateProvider) ->
  'ngInject'

  translations = {
    SERVICES: {
      PERSON_TABLE: {
        NEW_PERSON: 'New Person'
        DELETE: '@:CORE.COMMON.BTN.DELETE'
        EDIT: '@:CORE.COMMON.BTN.EDIT'
        SCHEDULE: 'Schedule'
      }
      RESOURCE_TABLE: {
        NEW_RESOURCE: 'New Resource'
        DELETE: '@:CORE.COMMON.BTN.DELETE'
        EDIT: '@:CORE.COMMON.BTN.EDIT'
        SCHEDULE: 'Schedule'
      }
      SERVICE_TABLE: {
        NEW_SERVICE: 'New Service'
        EDIT: '@:CORE.COMMON.BTN.EDIT'
        PROGRESS_BOOK: '@:CORE.COMMON.BTN.BOOK'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
