'use strict'

# Min/Max directives for use with number inputs
# Although angular provides min/max directives when using a HTML number input, the control does not validate if the field is actually a number
# so we have to use a text input with a ng-pattern that only allows numbers.
# http://jsfiddle.net/g/s5gKC/


angular.module('BB.Directives').directive "ngMax", ->
  restrict: "A"
  require: "ngModel"
  link: (scope, elem, attr, ctrl) ->

    maxValidator = (value) ->
      max = scope.$eval(attr.ngMax) # or Infinity
      ctrl.$setValidity "ngMax", (angular.isUndefined(value) or value is "" or value is null or value isnt value) or value <= max
      value

    ctrl.$parsers.push maxValidator
    ctrl.$formatters.push maxValidator
    return
