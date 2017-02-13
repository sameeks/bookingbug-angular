'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbBackgroundImage
* @restrict A
* @scope true
*
* @description
* Adds a background-image to an element

* @param
* {string} url
*
* @example
* <div bb-background-image='images/example.jpg'></div>
####
angular.module('BB.Directives').directive 'bbBackgroundImage', () ->
    restrict: 'A'
    scope: true
    link: (scope, el, attrs) ->
      return if !attrs.bbBackgroundImage or attrs.bbBackgroundImage == ""
      killWatch = scope.$watch attrs.bbBackgroundImage, (new_val, old_val) ->
        if new_val
          killWatch()
          el.css('background-image', 'url("' + new_val + '")')
