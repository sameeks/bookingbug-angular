'use strict'
angular.module('BB.Directives').directive 'bbQuestionLine', ($compile) ->
  transclude: false,
  restrict: 'A',
  link: (scope, element, attrs) ->
    if scope.question.detail_type == "heading"
      elm = ""
      if scope.question.name.length > 0
        elm += "<div class='bb-question-heading'>" + scope.question.name + "</div>"
      if scope.question.help_text && scope.question.help_text.length > 0
        elm += "<div class='bb-question-help-text'>" + scope.question.help_text + "</div>"
      element.html(elm)

    # are we using a completely custom question
    if scope.idmaps and ((scope.idmaps[scope.question.detail_type] and scope.idmaps[scope.question.detail_type].block) or
      (scope.idmaps[scope.question.id] && scope.idmaps[scope.question.id].block))
        index = if scope.idmaps[scope.question.id] then scope.question.id else scope.question.detail_type
        html = scope.$parent.idmaps[index].html
        e = $compile(html) scope, (cloned, scope) =>
          element.replaceWith(cloned)
