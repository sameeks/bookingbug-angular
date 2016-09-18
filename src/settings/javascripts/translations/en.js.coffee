'use strict';

angular.module('BBAdminSettings').config ($translateProvider) ->
  'ngInject'

  translations = {
    SETTINGS: {
      ADMIN_TABLE: {
        NEW_ADMINISTRATOR: 'New Administrator'
        EDIT: 'Edit'
      }
      ADMIN_FORM: {
        PROGRESS_CANCEL: 'Cancel'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
