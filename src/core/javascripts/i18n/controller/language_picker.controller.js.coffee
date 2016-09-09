'use strict'

angular.module('BB.i18n').controller 'languagePickerController', ($scope, $translate, TranslationOptions, $rootScope) ->
  'ngInject'

  ###jshint validthis: true ###
  vm = @

  vm.language = null
  vm.availableLanguages = []

  init = () ->
    vm.pickLanguage = pickLanguage

    setCurrentLanguage();
    loadAvailableLanguages();

    $scope.$on 'LanguagePicker:updateLanguage', setCurrentLanguage

    return

  setCurrentLanguage = () ->
    languageKey = $translate.use()
    if languageKey is 'undefined'
      languageKey = $translate.preferredLanguage()

    vm.language = {
      selected: {
        identifier: languageKey
        label     : 'COMMON.LANGUAGE.' + languageKey.toUpperCase()
      }
    }
    return

  loadAvailableLanguages = () ->
    angular.forEach TranslationOptions.available_languages, (languageKey, index) ->
      vm.availableLanguages.push {
        identifier: languageKey
        label     : 'COMMON.LANGUAGE.' + languageKey.toUpperCase()
      }
    return

  pickLanguage = (language) ->
    $translate.use language
    $rootScope.$broadcast 'LanguagePicker:changeLanguage'
    return

  init();

  return
