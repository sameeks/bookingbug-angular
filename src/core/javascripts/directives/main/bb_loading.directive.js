'use strict'

angular.module('BB.Directives').directive 'bbLoading', ($compile, $timeout, $bbug, LoadingService) ->
  link: (scope, element, attrs) ->
    scope.scopeLoaded = LoadingService.areScopesLoaded(scope)
    element.attr("ng-hide", "scopeLoaded")
    element.attr("bb-loading", null)

    positionLoadingIcon = () ->
      loading_icon = $bbug('.bb-loader').find('#loading_icon')
      wait_graphic = $bbug('.bb-loader').find('#wait_graphic')
      modal_open   = $bbug('[ng-app]').find('#bb').hasClass('modal-open')

      if modal_open
        $timeout ->
          center = $bbug('[ng-app]').find('.modal-dialog').height() or $bbug('[ng-app]').find('.modal-content').height() or $bbug('[ng-app]').find('.modal').height()
          center = (center / 2) - (wait_graphic.height() / 2)
          loading_icon.css("padding-top", center + "px")
        , 50
      else
        center = ($(window).innerHeight() / 2) - (wait_graphic.height() / 2)
        loading_icon.css("padding-top", center + "px")

    positionLoadingIcon()
    $bbug(window).on "resize", ->
      positionLoadingIcon()
    scope.$on "page:loaded", ->
      positionLoadingIcon()

    $compile(element)(scope)
    return
