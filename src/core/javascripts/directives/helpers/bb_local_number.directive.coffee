'use strict'


# bbLocalNumber
# Adds a formatter that prepends the model value with an appropriate prefix. This is useful for
# nicely formatting numbers where the prefix has been stripped, i.e. '7875123456'
# Adds a parser to store the user entered value which is then used in the formatter
angular.module('BB.Directives').directive 'bbLocalNumber', ($filter) ->
  restrict: 'A',
  scope: {},
  require: 'ngModel',
  link: (scope, element, attrs, ctrl) ->

    scope.userinput_mobile = null

    storeNumber = (value) ->
      if value
        scope.userinput_mobile = value
      return value

    prettyifyNumber = (value) ->
      if scope.userinput_mobile
        value = scope.userinput_mobile
      else
        return $filter('local_phone_number')(value)

    ctrl.$parsers.push(storeNumber)
    ctrl.$formatters.push(prettyifyNumber)
