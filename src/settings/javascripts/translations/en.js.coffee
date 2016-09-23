'use strict';

angular.module('BBAdminSettings').config ($translateProvider) ->
  'ngInject'

  translations = {
    SETTINGS: {
      ADMIN_TABLE: {
        NEW_ADMINISTRATOR: 'New Administrator'
        EDIT: '@:CORE.COMMON.BTN.EDIT'
      }
      ADMIN_FORM: {
        PROGRESS_CANCEL: '@:CORE.COMMON.BTN.CANCEL'
      }
    }
  }

  $translateProvider.translations('en', translations)

  return
