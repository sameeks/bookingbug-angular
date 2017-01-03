'use strict'


# bbPadWithZeros
# Adds a formatter that prepends the model value with the specified number of zeros
angular.module('BB.Directives').directive 'bbPadWithZeros', () ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attrs, ctrl) ->

    options  = scope.$eval(attrs.bbPadWithZeros) or {}
    how_many = options.how_many or 2

    padNumber = (value) ->
      value = String(value)
      if value and value.length < how_many
        padding = ""
        for index in [1..how_many-value.length]
          padding += "0"
         value = padding.concat(value)
      return value

    ctrl.$formatters.push(padNumber)
