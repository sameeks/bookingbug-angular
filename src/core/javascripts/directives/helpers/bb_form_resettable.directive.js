// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbFormResettable
// Adds field clearing behaviour to forms.
angular.module('BB.Directives').directive('bbFormResettable', $parse => {
        return {
            restrict: 'A',
            controller($scope, $element, $attrs) {
                $scope.inputs = [];

                $scope.resetForm = function (options) {
                    if (options && options.clear_submitted) {
                        $scope[$attrs.name].submitted = false;
                    }
                    return Array.from($scope.inputs).map((input) =>
                        (input.getter.assign($scope, null),
                            input.controller.$setPristine()));
                };

                return {
                    registerInput(input, ctrl) {
                        let getter = $parse(input);
                        return $scope.inputs.push({getter, controller: ctrl});
                    }
                };
            }
        };
    }
);
