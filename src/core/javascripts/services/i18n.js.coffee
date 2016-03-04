angular.module('BB.Services').factory 'I18nService', ($translate, $window, $q, angularLoad, $translationCache) ->
  supportedLocales = ['en', 'fr', 'de']
  defaultLocale = $translate.proposedLanguage() || 'en'
  initialized = false

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
    unless initialized
      initialized = true
      if multilingual
        supportedLocales = locales || supportedLocales
        this.setLocale($translate.proposedLanguage() || 'en').then -> $translate.refresh()
      else
        $translate.use('en')

  return factory
