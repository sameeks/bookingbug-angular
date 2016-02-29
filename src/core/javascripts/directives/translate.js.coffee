angular.module('pascalprecht.translate').config ($translateProvider, $translatePartialLoaderProvider) ->

  $translatePartialLoaderProvider.addPart('default');
  $translateProvider
    .useLoader('$translatePartialLoader', {
      urlTemplate: '/i18n/{part}/{lang}.json',
      loadFailureHandler: 'MyErrorHandler'
    })
    .determinePreferredLanguage () ->
      language = navigator.languages[0] or navigator.language or navigator.browserLanguage or navigator.systemLanguage or navigator.userLanguage or 'en'
      language.substr(0,2)
    .fallbackLanguage('en')
    .useCookieStorage()


angular.module('BB.Directives').directive 'bbTranslate', ($translate, $translatePartialLoader, $rootScope) ->
  restrict: 'AE'
  scope : false
  link: (scope, element, attrs) ->

    options = scope.$eval(attrs.bbTranslate) or {}

    scope.languages = [{name: 'en', key: 'EN'}, {name: 'de', key: 'DE'}, {name: 'fr', key: 'FR'}]

    scope.changeLanguage = (language) ->
      return if !language
      scope.selected_language = language
      moment.locale(language.name)
      $translate.use(language.name)
      # restart the widget 
      scope.clearBasketItem()
      scope.emptyBasket()
      scope.restart()

    if options.widget_lang
      $translatePartialLoader.addPart(options.widget_lang)
      $translate.refresh()
      scope.changeLanguage()


angular.module('BB.Services').factory 'MyErrorHandler', ($q, $log) ->
  return (part, lang) ->
    $log.error('The "' + part + '/' + lang + '" part was not loaded.')
    return $q.when({})
