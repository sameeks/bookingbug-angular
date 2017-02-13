'use strict'


# bbFormResettable
# Adds field clearing behaviour to forms.
angular.module('BB.Directives').directive 'bbFormResettable', ($parse) ->
  restrict: 'A'
  controller: ($scope, $element, $attrs) ->
    $scope.inputs = []

    $scope.resetForm = (options) ->
      $scope[$attrs.name].submitted = false if options and options.clear_submitted
      for input in $scope.inputs
        input.getter.assign($scope, null)
        input.controller.$setPristine()

    registerInput: (input, ctrl) ->
      getter = $parse input
      $scope.inputs.push({getter: getter, controller: ctrl})
