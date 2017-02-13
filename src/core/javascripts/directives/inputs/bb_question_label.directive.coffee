'use strict'

angular.module('BB.Directives').directive 'bbQuestionLabel', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: false,
  link: (scope, element, attrs) ->
    scope.$watch attrs.bbQuestionLabel, (question) ->
      if question
        if question.detail_type == "check" || question.detail_type == "check-price"
          element.html("")
