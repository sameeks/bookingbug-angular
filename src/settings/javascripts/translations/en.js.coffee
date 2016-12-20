"use strict";

angular.module("BBAdminSettings").config ($translateProvider) ->
  "ngInject"

  translations = {
    SETTINGS: {
      ADMIN_TABLE: {
        NEW_ADMINISTRATOR : "New Administrator"
        EDIT              : "@:COMMON.BTN.EDIT"
      }
      ADMIN_FORM: {
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
      }
    }
  }

  $translateProvider.translations("en", translations)

  return
