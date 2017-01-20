(function () {

    'use strict';

    angular.module('BB').service('bbWidgetStep', BBWidgetStep);

    function BBWidgetStep(BBModel, LoginService, $rootScope, bbWidgetPage) {

        var $scope = null;

        var setScope = function ($s) {
            $scope = $s;
        };
        var guardScope = function () {
            if ($scope === null) {
                throw new Error('please set scope');
            }
        };
        var setStepTitle = function (title) {
            guardScope();
            return $scope.bb.steps[$scope.bb.current_step - 1].title = title;
        };
        var checkStepTitle = function (title) {
            guardScope();
            if ($scope.bb.steps[$scope.bb.current_step - 1] && !$scope.bb.steps[$scope.bb.current_step - 1].title) {
                return setStepTitle(title);
            }
        };
        var getCurrentStepTitle = function () {
            var steps;
            guardScope();
            steps = $scope.bb.steps;
            if (!_.compact(steps).length || steps.length === 1 && steps[0].number !== $scope.bb.current_step) {
                steps = $scope.bb.allSteps;
            }
            if ($scope.bb.current_step) {
                return steps[$scope.bb.current_step - 1].title;
            }
        };
        var loadStep = function (step) {
            var i, len, prev_step, ref, st;
            guardScope();
            if (step === $scope.bb.current_step) {
                return;
            }
            $scope.bb.calculatePercentageComplete(step);
            st = $scope.bb.steps[step];
            prev_step = $scope.bb.steps[step - 1];
            if (st && !prev_step) {
                prev_step = st;
            }
            if (!st) {
                st = prev_step;
            }
            if (st && !$scope.bb.last_step_reached) {
                if (!st.stacked_length || st.stacked_length === 0) {
                    $scope.bb.stacked_items = [];
                }
                $scope.bb.current_item.loadStep(st.current_item);
                if ($scope.bb.steps.length > 1) {
                    $scope.bb.steps.splice(step, $scope.bb.steps.length - step);
                }
                $scope.bb.current_step = step;
                bbWidgetPage.showPage(prev_step.page, true);
            }
            if ($scope.bb.allSteps) {
                ref = $scope.bb.allSteps;
                for (i = 0, len = ref.length; i < len; i++) {
                    step = ref[i];
                    step.active = false;
                    step.passed = step.number < $scope.bb.current_step;
                }
                if ($scope.bb.allSteps[$scope.bb.current_step - 1]) {
                    return $scope.bb.allSteps[$scope.bb.current_step - 1].active = true;
                }
            }
        };

        /**
         * @ngdoc method
         * @name loadPreviousStep
         * @methodOf BB.Directives:bbWidget
         * @description
         * Loads the previous unskipped step
         *
         * @param {integer} steps_to_go_back: The number of steps to go back
         * @param {string} caller: The method that called this function
         */
        var loadPreviousStep = function (caller) {
            var last_step, pages_to_remove_from_history, past_steps, step_to_load;
            guardScope();
            past_steps = _.reject($scope.bb.steps, function (s) {
                return s.number >= $scope.bb.current_step;
            });
            step_to_load = 0;
            while (past_steps[0]) {
                last_step = past_steps.pop();
                if (!last_step) {
                    break;
                }
                if (!last_step.skipped) {
                    step_to_load = last_step.number;
                    break;
                }
            }
            if ($scope.bb.routeFormat) {
                pages_to_remove_from_history = step_to_load === 0 ? $scope.bb.current_step + 1 : $scope.bb.current_step - step_to_load;
                if (caller === "locationChangeStart") {
                    pages_to_remove_from_history--;
                }
                if (pages_to_remove_from_history > 0) {
                    window.history.go(pages_to_remove_from_history * -1);
                }
            }
            if (step_to_load > 0) {
                return loadStep(step_to_load);
            }
        };
        var loadStepByPageName = function (page_name) {
            var i, len, ref, step;
            guardScope();
            ref = $scope.bb.allSteps;
            for (i = 0, len = ref.length; i < len; i++) {
                step = ref[i];
                if (step.page === page_name) {
                    return loadStep(step.number);
                }
            }
            return loadStep(1);
        };
        var reset = function () {
            guardScope();
            $rootScope.$broadcast('clear:formData');
            $rootScope.$broadcast('widget:restart');
            setLastSelectedDate(null);
            if (!LoginService.isLoggedIn()) {
                $scope.client = new BBModel.Client();
            }
            $scope.bb.last_step_reached = false;
            return $scope.bb.steps.splice(1);
        };
        var restart = function () {
            guardScope();
            reset();
            return loadStep(1);
        };
        var setLastSelectedDate = function (date) {
            guardScope();
            return $scope.last_selected_date = date;
        };

        /**
         * @ngdoc method
         * @name skipThisStep
         * @methodOf BB.Directives:bbWidget
         * @description
         * Marks the current step as skipped
         */
        var skipThisStep = function () {
            if ($scope.bb.steps[$scope.bb.steps.length - 1]) {
                return $scope.bb.steps[$scope.bb.steps.length - 1].skipped = true;
            }
        };

        return {
            checkStepTitle: checkStepTitle,
            getCurrentStepTitle: getCurrentStepTitle,
            loadPreviousStep: loadPreviousStep,
            loadStep: loadStep,
            loadStepByPageName: loadStepByPageName,
            reset: reset,
            restart: restart,
            setLastSelectedDate: setLastSelectedDate,
            setScope: setScope,
            setStepTitle: setStepTitle,
            skipThisStep: skipThisStep
        };
    }
})();
