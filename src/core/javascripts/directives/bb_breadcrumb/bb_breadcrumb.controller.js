angular.module('BB.Controllers').controller('Breadcrumbs', function ($scope) {
    let {loadStep}        = $scope;
    $scope.steps = $scope.bb.steps;
    $scope.allSteps = $scope.bb.allSteps;

    // stop users from clicking back once the form is completed ###
    $scope.loadStep = function (number) {
        if (!lastStep() && !currentStep(number) && !atDisablePoint()) {
            return loadStep(number);
        }
    };


    var lastStep = () => $scope.bb.current_step === $scope.bb.allSteps.length;


    var currentStep = step => step === $scope.bb.current_step;


    var atDisablePoint = function () {
        if (!angular.isDefined($scope.bb.disableGoingBackAtStep)) {
            return false;
        }
        return $scope.bb.current_step >= $scope.bb.disableGoingBackAtStep;
    };


    return $scope.isDisabledStep = function (step) {
        if (lastStep() || currentStep(step.number) || !step.passed || atDisablePoint()) {
            return true;
        } else {
            return false;
        }
    };
});
