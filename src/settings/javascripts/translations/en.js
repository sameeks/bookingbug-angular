angular.module("BBAdminSettings").config(function ($translateProvider) {
    "ngInject";

    let translations = {
        SETTINGS: {
            ADMIN_TABLE: {
                NEW_ADMINISTRATOR: "New Administrator",
                EDIT: "@:COMMON.BTN.EDIT"
            },
            ADMIN_FORM: {
                OK_BTN: "@:COMMON.BTN.OK",
                CANCEL_BTN: "@:COMMON.BTN.CANCEL"
            }
        }
    };

    $translateProvider.translations("en", translations);

});
