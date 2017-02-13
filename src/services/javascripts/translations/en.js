// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module("BBAdminServices").config(function($translateProvider) {
  "ngInject";

  let translations = {
    SERVICES: {
      PERSON_TABLE: {
        NEW_PERSON : "New Person",
        DELETE     : "@:COMMON.BTN.DELETE",
        EDIT       : "@:COMMON.BTN.EDIT",
        SCHEDULE   : "@:COMMON.TERMINOLOGY.SCHEDULE"
      },
      RESOURCE_TABLE: {
        NEW_RESOURCE : "New Resource",
        DELETE       : "@:COMMON.BTN.DELETE",
        EDIT         : "@:COMMON.BTN.EDIT",
        SCHEDULE     : "@:COMMON.TERMINOLOGY.SCHEDULE"
      },
      SERVICE_TABLE: {
        NEW_SERVICE : "New Service",
        EDIT        : "@:COMMON.BTN.EDIT",
        BOOK_BTN    : "@:COMMON.BTN.BOOK"
      }
    }
  };

  $translateProvider.translations("en", translations);

});
