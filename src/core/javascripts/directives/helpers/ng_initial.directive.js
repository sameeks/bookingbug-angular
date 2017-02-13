'use strict'

angular.module('BB.Directives').directive 'ngInitial', ->
    restrict: 'A',
    controller: [
      '$scope', '$element', '$attrs', '$parse', ($scope, $element, $attrs, $parse) ->
        val = $attrs.ngInitial || $attrs.value
        getter = $parse($attrs.ngModel)
        setter = getter.assign
        if val == "true"
          val = true
        else if val == "false"
          val = false
        setter($scope, val)
    ]
