'use strict'

angular.module('BB.Directives').directive 'bbWaitFor', ($compile) ->
  transclude: false,
  restrict: 'A',
  priority: 800,
  link: (scope, element, attrs) ->
    name = attrs.bbWaitVar
    name ||= "allDone"
    scope[name] = false
    prom = scope.$eval(attrs.bbWaitFor)
    if !prom
      scope[name] = true
    else
      prom.then () ->
        scope[name] = true
    return
