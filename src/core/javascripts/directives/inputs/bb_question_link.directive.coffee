'use strict'

angular.module('BB.Directives').directive  'bbQuestionLink', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: true,
  link: (scope, element, attrs) ->
    id = parseInt(attrs.bbQuestionLink)
    scope.$watch "question_set", (newval, oldval) ->
      if newval
        for q in scope.question_set
          if q.id == id
            scope.question = q
            element.attr('ng-model',"question.answer")
            element.attr('bb-question-link',null)
            $compile(element)(scope)
