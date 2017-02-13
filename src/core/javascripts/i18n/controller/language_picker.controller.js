'use strict'

angular.module('BB.i18n').controller 'bbLanguagePickerController', (bbLocale, $locale, $rootScope, tmhDynamicLocale, $translate,
  bbi18nOptions, $scope) ->
  'ngInject'

  ###jshint validthis: true ###
  vm = @

  vm.language = null
  vm.availableLanguages = []
  vm.enableSearch = false

  init = () ->
    setAvailableLanguages();
    setCurrentLanguage();
    $scope.$on 'BBLanguagePicker:refresh', setCurrentLanguage
    vm.pickLanguage = pickLanguage
    return

  setAvailableLanguages = () ->
    angular.forEach bbi18nOptions.available_languages, (languageKey) ->
      vm.availableLanguages.push(createLanguage(languageKey))
    vm.enableSearch = vm.availableLanguages.length >= 10
    return

  setCurrentLanguage = () ->
    tmhDynamicLocale.set(bbLocale.getLocale()).then () ->
      vm.language =
        selected: createLanguage(bbLocale.getLocale())
      return

    return

  ###
  # @param {String]
  ###
  createLanguage = (languageKey) ->
    return {
      identifier: languageKey
      label: 'COMMON.LANGUAGE.' + languageKey.toUpperCase()
    }

  ###
  # @param {String]
  ###
  pickLanguage = (languageKey) ->
    tmhDynamicLocale.set(languageKey).then () ->
      bbLocale.setLocale(languageKey, 'bbLanguagePicker.pickLanguage')
      $rootScope.$broadcast 'BBLanguagePicker:languageChanged'
      return
    return

  init();

  return
