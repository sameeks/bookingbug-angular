'use strict'


angular.module('BB.Directives').directive  'bbCurrencyField', ($filter) ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attrs, ctrl) ->

    convertToCurrency = (value) ->
      value / 100

    convertToInteger = (value) ->
      value * 100

    ctrl.$formatters.push(convertToCurrency)
    ctrl.$parsers.push(convertToInteger)
