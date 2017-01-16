'use strict'

angular.module('BB.Directives').directive 'ngDelayed',  ($compile) ->
    link: (scope, element, attr) ->
      scope[attr.ngDelayedWatch].then (logged) =>
        element.attr(attr.ngDelayed, attr.ngDelayedValue)
        element.attr('ng-delayed-value',null)
        element.attr('ng-delayed-watch',null)
        element.attr('ng-delayed',null)
        $compile(element)(scope)
        if attr.ngDelayedReady
          scope[attr.ngDelayedReady].resolve(true)
