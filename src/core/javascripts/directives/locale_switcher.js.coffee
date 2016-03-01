angular.module('BB.Directives').directive 'bbLocaleSwitcher', (I18nService) ->
  restrict: 'AE'
  scope: false
  templateUrl: 'locale_switcher.html'
  link: (scope, element, attrs) ->
    scope.LANGUAGES = I18nService.getSupportedLocales().map((s) -> s.toUpperCase())
    scope.currentLanguage = I18nService.getDefaultLocale().toUpperCase()

    scope.changeLanguage = (language) ->
      I18nService.setLocale(language.toLowerCase())
      scope.currentLanguage = language

      scope.clearBasketItem()
      scope.emptyBasket()
      scope.restart()
