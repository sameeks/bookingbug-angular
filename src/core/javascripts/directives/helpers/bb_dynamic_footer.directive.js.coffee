'use strict'


angular.module('BB.Directives').directive 'bbDynamicFooter', ($timeout, $bbug) ->
  (scope, el, attrs) ->

    scope.$on "page:loaded", ->
      $bbug('.content').css('height', 'auto')

    scope.$watch -> $bbug('.content')[0].scrollHeight,
    (new_val, old_val) ->
      if new_val != old_val
        scope.setContentHeight()

    scope.setContentHeight = ->
      $bbug('.content').css('height', 'auto')
      content_height = $bbug('.content')[0].scrollHeight
      min_content_height = $bbug(window).innerHeight() - $bbug('.content').offset().top - $bbug('.footer').height()
      if content_height < min_content_height
        $bbug('.content').css('height', min_content_height + 'px')

    $bbug(window).on 'resize', ->
      scope.setContentHeight()
