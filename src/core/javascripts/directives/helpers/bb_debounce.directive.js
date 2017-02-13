'use strict'

angular.module('BB.Directives').directive 'bbDebounce', ($timeout) ->
  restrict: 'A',
  link: (scope, element, attrs) ->
    delay = 400
    delay = attrs.bbDebounce if attrs.bbDebounce

    element.bind 'click', () =>
      $timeout () =>
        element.attr('disabled', true)
      , 0
      $timeout () =>
        element.attr('disabled', false)
      , delay
