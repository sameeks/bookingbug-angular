angular.module('BB.Services').factory 'I18nService', ($translate, $window, $q, angularLoad, $translationCache) ->
  supported_locales = ['en', 'fr', 'de']
  default_locale = $translate.proposedLanguage() || 'en'
  initialized = false

  #angular-translate custom loader that just gets keys from window.BB_TRANSLATIONS
  factory = (options) ->
    $q.when($window.bookingbug.translations[options.key])

  #interface
  factory.setLocale = (locale) ->
    loading_promise = if locale is 'en' then $q.when() else angularLoad.loadScript("i18n/#{locale}.js")
    loading_promise.then ->
      $translate.use(locale)
      moment.locale(locale)

  factory.getDefaultLocale = -> default_locale
  factory.getSupportedLocales = -> supported_locales

  factory.init = (multilingual, locales) ->
    unless initialized
      initialized = true
      if multilingual
        supported_locales = locales || supported_locales
        this.setLocale($translate.proposedLanguage() || 'en').then -> $translate.refresh()
      else
        $translate.use('en')

  return factory
