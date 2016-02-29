angular.module('pascalprecht.translate').config ($translateProvider, $translatePartialLoaderProvider) ->
  $translatePartialLoaderProvider.addPart('default')
  $translateProvider
    .useLoader('$translatePartialLoader', {
      urlTemplate: '/i18n/{part}/{lang}.json'
    })
    .useCookieStorage()


angular.module('BB.Directives').requires.push('angularLoad')
angular.module('BB.Directives').directive 'bbTranslate', ($translate, $translatePartialLoader, $rootScope, angularLoad) ->
  restrict: 'AE'
  scope : false
  link: (scope, element, attrs) ->

    options = scope.$eval(attrs.bbTranslate) or {}

    scope.languages = [{name: 'en', key: 'EN'}, {name: 'de', key: 'DE'}, {name: 'fr', key: 'FR'}]

    scope.changeLanguage = (language) ->
      return if !language
      scope.selected_language = language
      # annoyingly, moment.locale(string, loadCallback, localePath) has been removed :'(
      if language.name == 'en'
        moment.locale('en')
      else
        angularLoad.loadScript("/i18n/momentjs/#{language.name}.js").then ->
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
