'use strict'

app = angular.module 'BB.Directives'

app.directive 'bbDisplayMode', ($compile, $window, $bbug, ViewportSize) ->
  {
    transclude: false,
    restrict: 'A',
    template: '<span class="visible-xs">&nbsp;</span><span class="visible-sm">&nbsp;</span><span class="visible-md">&nbsp;</span><span class="visible-lg">&nbsp;</span>',
    link: (scope, elem, attrs) ->

      scope.getSize = () ->
        console.log ViewportSize.getViewportSize()

      # markers = elem.find('span')
      # $bbug(elem).addClass("bb-display-mode")
      # scope.display = {}
      # previous_size = null

      # isVisible = (element) ->
      #   return element && element.style.display != 'none' && element.offsetWidth && element.offsetHeight

      # getCurrentSize = () ->
      #   currentSize = false
      #   for element in markers
      #     if isVisible(element)
      #       currentSize = element.className[8..10]
      #       ViewportSize.setViewportSize(element.className[8..10])
      #       break

      #   return currentSize

      # update = () =>

      #   nsize = getCurrentSize()
      #   if nsize != previous_size
      #     previous_size = nsize
      #     scope.display.xs = false
      #     scope.display.sm = false
      #     scope.display.md = false
      #     scope.display.lg = false
      #     scope.display.not_xs = true
      #     scope.display.not_sm = true
      #     scope.display.not_md = true
      #     scope.display.not_lg = true

      #     scope.display[nsize] = true
      #     scope.display["not_" + nsize] = false

      #     return true
      #   return false

      # t = null
      # angular.element($window).bind 'resize', () =>
      #   window.clearTimeout(t)
      #   t = setTimeout () ->
      #     if update()
      #       scope.$apply()
      #   , 50

      # angular.element($window).bind 'load', () =>
      #   if update()
      #     scope.$apply()
  }

