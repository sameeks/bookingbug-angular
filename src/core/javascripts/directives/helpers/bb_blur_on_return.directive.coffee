'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbBlurOnReturn
* @restrict A
* @scope true
*
* @description
* Removes focus from an input[type=text] element when return key is pressed
* @example
* <input type='text' bb-blur-on-return></div>
####
angular.module('BB.Directives').directive('bbBlurOnReturn', ($timeout) ->
  restrict: 'A'
  require: 'ngModel'
  link: (scope, el, attrs) ->
    el.keydown((e) ->
      key = e.which or e.keyCode
      if key == 13 or key == '13'
        $timeout( () ->
          e.target.blur() if e.target
        , 10
        )
    )
)
