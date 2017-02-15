angular.module('BB.i18n').config(function ($translateProvider) {
    'ngInject';

    let translations = {
        I18N: {
            LANGUAGE_PICKER: {
                SELECT_LANG_PLACEHOLDER: 'Select...'
            }
        }
    };

    $translateProvider.translations('en', translations);

});
