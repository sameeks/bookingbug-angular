angular.module('BB.i18n').run(function ($localStorage, bbi18nOptions, bbLocale, RuntimeTranslate, bbTimeZoneOptions) {
    'ngInject';

    RuntimeTranslate.registerAvailableLanguageKeys(
        bbi18nOptions.available_languages,
        bbi18nOptions.available_language_associations
    );

    bbLocale.determineLocale();
    bbTimeZoneOptions.determineTimeZone();

});
