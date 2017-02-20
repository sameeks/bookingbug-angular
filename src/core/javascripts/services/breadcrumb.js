angular.module('BB.Services').factory("BreadcrumbService", function () {

    let current_step = 1;

    return {
        setCurrentStep(step) {
            return current_step = step;
        },

        getCurrentStep() {
            return current_step;
        }
    };
});

