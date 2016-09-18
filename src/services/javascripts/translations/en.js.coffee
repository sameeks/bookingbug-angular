'use strict';

angular.module('BBAdminServices').config ($translateProvider) ->
  'ngInject'

  translations = {
    SERVICES: {
      PERSON_TABLE: {
        NEW_PERSON: 'New Person'
        DELETE: 'Delete'
        EDIT: 'Edit'
        SCHEDULE: 'Schedule'
      }
      RESOURCE_TABLE: {
        NEW_RESOURCE: 'New Resource'
        DELETE: 'Delete'
        EDIT: 'Edit'
        SCHEDULE: 'Schedule'
      }
      SERVICE_TABLE: {
        NEW_SERVICE: 'New Service'
        EDIT: 'Edit'
        PROGRESS_BOOK: 'Book'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
