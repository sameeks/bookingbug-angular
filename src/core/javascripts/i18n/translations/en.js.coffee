'use strict';

angular.module('BB.i18n').config ($translateProvider) ->
  'ngInject'

  translations = {
    I18N: {
      LANGUAGE_PICKER: {
        SELECT_LANG_PLACEHOLDER: 'Select...'
      } 
    }
  }

  $translateProvider.translations('en', translations)

  return
