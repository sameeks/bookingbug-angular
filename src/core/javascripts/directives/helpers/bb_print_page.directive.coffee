'use strict'


angular.module('BB.Directives').directive 'bbPrintPage', ($window, $timeout) ->
  restrict: 'A',
  link:(scope, element, attr) ->
    if attr.bbPrintPage
      scope.$watch attr.bbPrintPage, (newVal, oldVal) =>
        $timeout(->
          $window.print()
        3000)
