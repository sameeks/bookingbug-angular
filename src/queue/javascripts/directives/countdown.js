angular.module('BBQueue.directives').directive('countdown', function() {

    let controller = $scope => {

        $scope.$watch('$$value$$', function(value) {
            if (value != null) {
                return $scope.updateModel(value);
            }
        });

    }

    let link = function(scope, element, attrs, ngModel) {

        ngModel.$render = function() {
            if (ngModel.$viewValue) {
                return scope.$$value$$ = ngModel.$viewValue;
            }
        };

        scope.updateModel = function(value) {
            ngModel.$setViewValue(value);

            let secs = parseInt((value % 60).toFixed(0));
            let mins = parseInt((value / 60).toFixed(0));

            if (mins > 1) {
                return scope.due = `${mins} Mins`;
            } else if (mins === 1) {
                return scope.due = "1 Min";
            } else if ((mins === 0) && (secs > 10)) {
                return scope.due = "< 1 Min";
            } else {
                return scope.due = "Next Up";
            }
        };

        return scope.due = "";
    };

    return {
        require: 'ngModel',
        link,
        controller,
        scope: {
            min: '@'
        },
        template: `{{due}}`
    };
});
