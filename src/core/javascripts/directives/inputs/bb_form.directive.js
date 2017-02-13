// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
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
let bbFormDirective = function($bbug, $window, ValidatorService, $timeout, GeneralOptions) {
  'ngInject';

  let link = function(scope, elem, attrs, ctrls) {

    let $bbPageCtrl = null;
    let $formCtrl = null;

    let init = function() {

      $formCtrl = ctrls[0];
      $bbPageCtrl = ctrls[1];
      scope.submitForm = submitForm;
      elem.on("submit", submitForm); // doesn't work with ng-form just regular form
    };

    // marks child forms as submitted
    // See https://github.com/angular/angular.js/issues/10071
    var setSubmitted = function(form) {

      form.$setSubmitted();
      form.submitted = true; // DEPRECATED - $submitted should be used in favour
      return angular.forEach(form, function(item) {
        if (item && (item.$$parentForm === form) && item.$setSubmitted) { return setSubmitted(item); }
      });
    };


    var submitForm = function() {

      setSubmitted($formCtrl);

      $timeout(scrollAndFocusOnInvalid, 100);

      let isValid = ValidatorService.validateForm($formCtrl);

      if (isValid) {
        serveBBPage();
      }

      return isValid;
    };

    var serveBBPage = function() {

      if ($bbPageCtrl != null) {
        
        let route = attrs.bbFormRoute;
        $bbPageCtrl.$scope.checkReady();

        if ((route != null) && (route.length > 0)) {
          $bbPageCtrl.$scope.routeReady(route);
        } else {
          $bbPageCtrl.$scope.routeReady();
        }
      }

    };

    var scrollAndFocusOnInvalid = function() {

      let invalidFormGroup = elem.find('.has-error:first');

      if (invalidFormGroup && (invalidFormGroup.length > 0) && !$formCtrl.raise_alerts) {

        if ('parentIFrame' in $window) {
          parentIFrame.scrollToOffset(0, invalidFormGroup.offset().top - GeneralOptions.scroll_offset);
        } else {
          $bbug("html, body").animate(
            {scrollTop: invalidFormGroup.offset().top - GeneralOptions.scroll_offset}
          , 1000);
        }

        let invalidInput = invalidFormGroup.find('.ng-invalid');
        invalidInput.focus();
        return;
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
