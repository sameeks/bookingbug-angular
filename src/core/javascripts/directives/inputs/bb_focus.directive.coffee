'use strict'


# Directive for testing if a input is focused
# Provided by http://www.ng-newsletter.com/posts/validations.html
angular.module('BB.Directives').directive "bbFocus", [->
    FOCUS_CLASS = "bb-focused"
    {
      restrict: "A",
      require: "ngModel",
      link: (scope, element, attrs, ctrl) ->
        ctrl.$focused = false
        element.bind("focus", (evt) ->
          element.addClass FOCUS_CLASS
          scope.$apply ->
            ctrl.$focused = true

        ).bind "blur", (evt) ->
          element.removeClass FOCUS_CLASS
          scope.$apply ->
            ctrl.$focused = false
    }
]
