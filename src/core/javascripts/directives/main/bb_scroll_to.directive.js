'use strict'

# bbScrollTo
# Allows you to scroll to a specific element
angular.module('BB.Directives').directive 'bbScrollTo', ($rootScope, AppConfig, BreadcrumbService, $bbug, $window, GeneralOptions, viewportSize) ->
  transclude: false,
  restrict: 'A',
  link: (scope, element, attrs) ->

    evnts = attrs.bbScrollTo.split(',')
    always_scroll = attrs.bbAlwaysScroll? or false
    bb_transition_time = if attrs.bbTransitionTime? then parseInt(attrs.bbTransitionTime, 10) else 500

    if angular.isArray(evnts)
      angular.forEach evnts, (evnt) ->
        scope.$on evnt, (e) ->
          scrollToCallback(evnt)
    else
      scope.$on evnts, (e) ->
        scrollToCallback(evnts)

    isElementInView = (el) ->
      return el.offset().top > $bbug('body').scrollTop() and el.offset().top < ($bbug('body').scrollTop() + $bbug(window).height())

    scrollToCallback = (evnt) ->
      if evnt == "page:loaded" && viewportSize.isXS() && $bbug('[data-scroll-id="'+AppConfig.uid+'"]').length
        scroll_to_element = $bbug('[data-scroll-id="'+AppConfig.uid+'"]')
      else
        scroll_to_element = $bbug(element)

      current_step = BreadcrumbService.getCurrentStep()

      # if the event is page:loaded or the element is not in view, scroll to it
      if (scroll_to_element)
        if (evnt == "page:loaded" and current_step > 1) or always_scroll or (evnt == "widget:restart") or
          (not isElementInView(scroll_to_element) and scroll_to_element.offset().top != 0)
            if 'parentIFrame' of $window
              parentIFrame.scrollToOffset(0, scroll_to_element.offset().top - GeneralOptions.scroll_offset)
            else
              $bbug("html, body").animate
                scrollTop: scroll_to_element.offset().top - GeneralOptions.scroll_offset
                , bb_transition_time
