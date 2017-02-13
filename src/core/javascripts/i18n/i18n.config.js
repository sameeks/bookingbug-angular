angular.module('BB.i18n').config(function(bbi18nOptionsProvider, tmhDynamicLocaleProvider, $translateProvider) {
  'ngInject';

  // sanitize just the translation text using the sanitize strategy as interpolation
  // param sanitization (sanitizeParameters) invalidates moment objects
  $translateProvider.useSanitizeValueStrategy('escape'); // TODO use sanitize strategy once it's reliable: https://angular-translate.github.io/docs/#/guide/19_security

  $translateProvider.useLocalStorage();

  $translateProvider.addInterpolation('$translateMessageFormatInterpolation');

  $translateProvider.fallbackLanguage(bbi18nOptionsProvider.getOption('available_languages'));

  tmhDynamicLocaleProvider.localeLocationPattern('angular-i18n/angular-locale_{{locale}}.js');

  tmhDynamicLocaleProvider.useCookieStorage();

});
