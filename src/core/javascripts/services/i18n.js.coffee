angular.module('BB.Services').factory 'I18nService', ($translate, $window, angularLoad) ->
  setMomentLocale = (locale) ->
    if locale == 'en'
      moment.locale('en')
    else
      # annoyingly, moment.locale(string, loadCallback, localePath) has been removed :'(
      angularLoad.loadScript("i18n/momentjs/#{locale}.js").then ->
        moment.locale(locale)
  supportedLocales = ['en', 'fr', 'de']
  return {
    setLocale: (locale) ->
      $translate.use(locale)
      setMomentLocale(locale)
    getSupportedLocales: -> supportedLocales
    init: (multilingual, locales) ->
      if multilingual
        supportedLocales = locales || supportedLocales
        setMomentLocale($translate.use())
      else
        $translate.use('en')
  }
