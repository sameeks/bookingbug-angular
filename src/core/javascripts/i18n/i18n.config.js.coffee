'use strict'

angular.module('BB.i18n').config ($translateProvider, TranslationOptionsProvider) ->
  'ngInject'

  $translateProvider.useSanitizeValueStrategy('sanitizeParameters'); # TODO use sanitize strategy once it's reliable: https://angular-translate.github.io/docs/#/guide/19_security

  $translateProvider.useLocalStorage()

  $translateProvider.fallbackLanguage(TranslationOptionsProvider.getOption('available_languages'))

  return
