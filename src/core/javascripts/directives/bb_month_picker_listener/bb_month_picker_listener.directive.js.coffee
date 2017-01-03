'use strict'

angular.module('BB.Directives').directive 'bbMonthPickerListener', (PathSvc, $timeout) ->
  restrict: 'A'
  scope: true
  link: (scope, el, attrs) ->
    $(window).resize () ->
      $timeout ->
        scope.carouselIndex = 0

    scope.$on 'event_list_filter:changed', () ->
      $timeout ->
        scope.carouselIndex = 0