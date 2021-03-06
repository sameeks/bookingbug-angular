/**
 * @ngdoc directive
 * @name BB.Directives:bbForm
 * @restrict A
 * @scope true
 *
 * @description
 * Use with forms to add enhanced validation.
 * When using with ng-form, submitForm needs to be called manually as submit event is not raised.
 *
 * @example
 * <div ng-form name="example_form" bb-form></div>
 * <form name="example_form" bb-form></form>
 */
let bbFormDirective = function ($bbug, $window, ValidatorService, $timeout, GeneralOptions, scrollIntercepter) {
    'ngInject';

    let link = function (scope, elem, attrs, ctrls) {

        let $bbPageCtrl = null;
        let $formCtrl = null;

        let init = function () {

            $formCtrl = ctrls[0];
            $bbPageCtrl = ctrls[1];
            scope.submitForm = submitForm;
            if (attrs.disableAutoSubmit == null) elem.on("submit", submitForm); // doesn't work with ng-form just regular form
        };

        // marks child forms as submitted
        // See https://github.com/angular/angular.js/issues/10071
        var setSubmitted = function (form) {

            form.$setSubmitted();
            form.submitted = true; // DEPRECATED - $submitted should be used in favour
            angular.forEach(form, function (item) {
                if (item && (item.$$parentForm === form) && item.$setSubmitted) setSubmitted(item);
            });
        };


        var submitForm = function () {

            setSubmitted($formCtrl);

            $timeout(scrollAndFocusOnInvalid, 100);

            let isValid = ValidatorService.validateForm($formCtrl);

            if (isValid && $bbPageCtrl != null && attrs.noRoute == null) serveBBPage();

            return isValid;
        };

        var serveBBPage = function () {

            let route = attrs.bbFormRoute;
            $bbPageCtrl.$scope.checkReady();

            if ((route != null) && (route.length > 0)) {
                $bbPageCtrl.$scope.routeReady(route);
            } else {
                $bbPageCtrl.$scope.routeReady();
            }
        };

        var scrollAndFocusOnInvalid = function () {

            let invalidFormGroup = elem.find('.has-error:first');

            if (invalidFormGroup && (invalidFormGroup.length > 0) && !$formCtrl.raise_alerts) {

                scrollIntercepter.scrollToElement(invalidFormGroup, 1000, 'form:invalid');

                let invalidInput = invalidFormGroup.find('.ng-invalid');
                invalidInput.focus();
            }
        };

        init();

    };

    return {
        restrict: 'A',
        require: ['^form', '?^^bbPage'],
        scope: 'true',
        link
    };
};

angular.module('BB.Directives').directive('bbForm', bbFormDirective);
