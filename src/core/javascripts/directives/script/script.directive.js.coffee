'use strict'

angular.module('BB.Directives').directive 'script', ($compile, halClient) ->
  transclude: false,
  restrict: 'E',
  link: (scope, element, attrs) ->
    if (attrs.type == 'text/hal-object')
      body = element[0].innerText
      json = $bbug.parseJSON(body)
      res = halClient.$parse(json)

