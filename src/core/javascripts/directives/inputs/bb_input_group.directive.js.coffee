'use strict'


angular.module('BB.Directives').directive  "bbInputGroup", () ->
  restrict: "A",
  require: 'ngModel',
  link: (scope, elem, attrs, ngModel) ->

    # return if the input has already been registered
    return if scope.input_manger.inputs.indexOf(ngModel.$name) >= 0

    # register the input
    scope.input_manger.registerInput(ngModel, attrs.bbInputGroup)

    # watch the input for changes
    scope.$watch attrs.ngModel, (newval, oldval) ->
      scope.input_manger.validateInputGroup(attrs.bbInputGroup) if newval is not oldval
