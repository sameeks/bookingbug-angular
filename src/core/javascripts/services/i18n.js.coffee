angular.module('BB.Services').factory 'I18nService', ($translate, $window, $q, angularLoad, $translationCache) ->
  defaultLocale = $translate.proposedLanguage() || 'en'
  supportedLocales = ['en', 'fr', 'de']

  #angular-translate custom loader that just gets keys from window.BB_TRANSLATIONS
  factory = (options) ->
    $q.when($window.bookingbug.translations[options.key])

  #interface
  factory.setLocale = (locale) ->
    loadingPromise = if locale is 'en' then $q.when() else angularLoad.loadScript("i18n/#{locale}.js")
    loadingPromise.then ->
      $translate.use(locale)
      moment.locale(locale)

  factory.getDefaultLocale = -> defaultLocale
  factory.getSupportedLocales = -> supportedLocales

  factory.init = (multilingual, locales) ->
    if multilingual
      supportedLocales = locales || supportedLocales
      this.setLocale(defaultLocale)
    else
      $translate.use('en')

  return factory
