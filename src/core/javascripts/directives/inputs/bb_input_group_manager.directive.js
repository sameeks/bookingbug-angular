// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbInputGroupManager
// Allows you you register inputs
angular.module('BB.Directives').directive('bbInputGroupManager', ValidatorService => {
        return {
            restrict: 'A',
            controller($scope, $element, $attrs) {
                //$scope.
                $scope.input_manger = {

                    input_groups: {},
                    inputs: [],

                    registerInput(input, name) {

                        // return if the input has already been registered
                        if (this.inputs.indexOf(input.$name) >= 0) {
                            return;
                        }

                        this.inputs.push(input.$name);

                        // group the input by the name provided
                        if (!this.input_groups[name]) {
                            this.input_groups[name] = {
                                inputs: [],
                                valid: false
                            };
                        }

                        return this.input_groups[name].inputs.push(input);
                    },

                    validateInputGroup(name) {
                        let is_valid = false;
                        for (var input of Array.from(this.input_groups[name].inputs)) {
                            is_valid = input.$modelValue;
                            if (is_valid) {
                                break;
                            }
                        }

                        if (is_valid === !this.input_groups[name].valid) {

                            for (input of Array.from(this.input_groups[name].inputs)) {
                                input.$setValidity(input.$name, is_valid);
                            }

                            return this.input_groups[name].valid = is_valid;
                        }
                    }

                };

                // on form submit, validate all input groups
                return $element.on("submit", () =>
                    (() => {
                        let result = [];
                        for (let input_group in $scope.input_manger.input_groups) {
                            result.push($scope.input_manger.validateInputGroup(input_group));
                        }
                        return result;
                    })()
                );
            }
        };
    }
);
