'use strict'

# Input match test
angular.module('BB.Directives').directive "bbMatchInput", ->
  restrict: "A"
  require: 'ngModel'
  link: (scope, element, attrs, ctrl, ngModel) ->

    scope.$watch attrs.bbMatchInput, ->
      scope.val_1 = scope.$eval(attrs.bbMatchInput)
      compare(ctrl.$viewValue)

    compare = (value) ->
      ctrl.$setValidity 'match', scope.val_1 == value
      value

    ctrl.$parsers.push compare
