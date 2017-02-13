// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.i18n').run(function(bbi18nOptions, bbLocale, RuntimeTranslate) {
  'ngInject';

  RuntimeTranslate.registerAvailableLanguageKeys(
    bbi18nOptions.available_languages,
    bbi18nOptions.available_language_associations
  );

  bbLocale.determineLocale();
});
