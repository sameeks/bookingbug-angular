'use strict'

angular.module('BB.Directives').directive 'ngValidInclude', ($compile) ->
    link: (scope, element, attr) ->
      scope[attr.watchValue].then (logged) =>
        element.attr('ng-include', attr.ngValidInclude)
        element.attr('ng-valid-include',null)
        $compile(element)(scope)
