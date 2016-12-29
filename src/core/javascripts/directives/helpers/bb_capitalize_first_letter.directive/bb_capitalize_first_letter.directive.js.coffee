'use strict'


# bbCapitaliseFirstLetter
angular.module('BB.Directives').directive 'bbCapitaliseFirstLetter', () ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->
    ngModel = ctrls[0]

    scope.$watch attrs.ngModel, (newval, oldval) ->
      if newval
        string = scope.$eval attrs.ngModel
        string = string.charAt(0).toUpperCase() + string.slice(1)
        ngModel.$setViewValue(string)
        ngModel.$render()
        return
