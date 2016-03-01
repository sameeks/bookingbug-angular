angular.module('BB.Services').factory 'I18nService', ($translate, $window, angularLoad) ->
  setMomentLocale = (locale) ->
    if locale == 'en'
      moment.locale('en')
    else
      # annoyingly, moment.locale(string, loadCallback, localePath) has been removed :'(
      angularLoad.loadScript("i18n/momentjs/#{locale}.js").then ->
        moment.locale(locale)
  supportedLocales = ['en', 'fr', 'de']
  defaultLocale = $translate.proposedLanguage() || 'en'
  return {
    setLocale: (locale) ->
      $translate.use(locale)
      setMomentLocale(locale)
    getDefaultLocale: -> defaultLocale
    getSupportedLocales: -> supportedLocales
    init: (multilingual, locales) ->
      if multilingual
        supportedLocales = locales || supportedLocales
        this.setLocale(defaultLocale)
      else
        $translate.use('en')
  }
