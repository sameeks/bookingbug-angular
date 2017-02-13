'use strict'

angular.module('BB.Directives').directive  'bbQuestionSet', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: true,
  link: (scope, element, attrs) ->
    set = attrs.bbQuestionSet
    element.addClass 'ng-hide'
    scope.$watch set, (newval, oldval) ->
      if newval
        scope.question_set = newval
        element.removeClass 'ng-hide'
