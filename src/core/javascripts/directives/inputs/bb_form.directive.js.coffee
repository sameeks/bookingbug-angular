'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbForm
* @restrict A
* @scope true
*
* @description
* Use with forms to add enhanced validation. When using with ng-form, submitForm
* needs to be called manually as submit event is not raised.

*
* @example
* <div ng-form name="example_form" bb-form></div>
* <form name="example_form" bb-form></form>
*
####
angular.module('BB.Directives').directive 'bbForm', ($bbug, $window, ValidatorService, $timeout, GeneralOptions) ->
  restrict: 'A'
  require: '^form'
  scope: true
  link: (scope, elem, attrs, ctrls) ->

    scope.form = ctrls

    # set up event handler on the form element
    elem.on "submit", ->
      scope.submitForm()
      scope.$apply()


    scope.submitForm = () ->

      scope.form.submitted = true

      # mark nested forms as submitted too
      for property of scope.form
        if angular.isObject(scope.form[property]) and scope.form[property].hasOwnProperty('$valid')
          scope.form[property].submitted = true

      $timeout ->
        invalid_form_group = elem.find('.has-error:first')

        if invalid_form_group and invalid_form_group.length > 0 and !scope.form.raise_alerts

          if 'parentIFrame' of $window
            parentIFrame.scrollToOffset(0, invalid_form_group.offset().top - GeneralOptions.scroll_offset)
          else
            $bbug("html, body").animate
              scrollTop: invalid_form_group.offset().top - GeneralOptions.scroll_offset
              , 1000

          invalid_input = invalid_form_group.find('.ng-invalid')
          invalid_input.focus()
      , 100

      return ValidatorService.validateForm(scope.form)
