'use strict'

angular.module('BB.Directives').directive 'bbQuestionSetup', ->
  restrict: 'A'
  terminal: true
  priority: 1000

  link: (scope, element, attrs) ->
    idmaps = {}
    def = null
    for child, index in element.children()
      id = $(child).attr("bb-question-id")
      block = false
      if $(child).attr("bb-replace-block")
        block = true
      # replace form name with something unique to ensure custom questions get registered
      # with the form controller and subjected to validation
      child.innerHTML = child.innerHTML.replace(/question_form/g, "question_form_#{index}")
      idmaps[id] = {id: id, html: child.innerHTML, block: block}
    scope.idmaps = idmaps
    element.replaceWith("")
