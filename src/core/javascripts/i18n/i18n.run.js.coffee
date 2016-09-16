'use strict'

angular.module('BB.i18n').run ($translate, TranslationOptions, RuntimeTranslate) ->
  'ngInject'

  RuntimeTranslate.registerAvailableLanguageKeys(
    TranslationOptions.available_languages,
    TranslationOptions.available_language_associations
  )

  $translate.preferredLanguage TranslationOptions.default_language

  if TranslationOptions.use_browser_language
    browserLocale = $translate.negotiateLocale($translate.resolveClientLocale())

    if _.contains(TranslationOptions.available_languages, browserLocale)
      $translate.preferredLanguage browserLocale

  return
