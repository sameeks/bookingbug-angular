'use strict'
# bbInputGroupManager
# Allows you you register inputs
angular.module('BB.Directives').directive 'bbInputGroupManager', (ValidatorService) ->
  restrict: 'A'
  controller: ($scope, $element, $attrs) ->
    #$scope.
    $scope.input_manger = {

      input_groups: {}
      inputs      : []

      registerInput: (input, name) ->

        # return if the input has already been registered
        return if @inputs.indexOf(input.$name) >= 0

        @inputs.push(input.$name)

        # group the input by the name provided
        if not @input_groups[name]
          @input_groups[name] = {
            inputs : [],
            valid  : false
          }

        @input_groups[name].inputs.push(input)

      validateInputGroup: (name) ->
        is_valid = false
        for input in @input_groups[name].inputs
          is_valid = input.$modelValue
          break if is_valid

        if is_valid is not @input_groups[name].valid

          for input in @input_groups[name].inputs
            input.$setValidity(input.$name,is_valid)

          @input_groups[name].valid = is_valid

    }

    # on form submit, validate all input groups
    $element.on "submit", ->
      for input_group of $scope.input_manger.input_groups
        $scope.input_manger.validateInputGroup(input_group)
