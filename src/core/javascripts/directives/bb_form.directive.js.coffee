'use strict'

###*
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
###
bbFormDirective = ($bbug, $window, ValidatorService, $timeout, GeneralOptions) ->
  'ngInject'

  link = (scope, elem, attrs, ctrls) ->
    $bbPageCtrl = null

    init = ->
      scope.form = ctrls[0]
      $bbPageCtrl = ctrls[1]
      scope.submitForm = submitForm
      elem.on "submit", submitForm #doesn't work with ng-form just regular form
      return

    submitForm = () ->
      scope.form.$setSubmitted()
      $timeout(scrollAndFocusOnInvalid, 100)

      isValid = ValidatorService.validateForm(scope.form)

      if isValid
        serveBBPage()

      return isValid

    serveBBPage = () ->
      if $bbPageCtrl? and attrs.bbFormRoute?
        route = attrs.bbFormRoute
        $bbPageCtrl.$scope.checkReady()
        if route.length > 0
          $bbPageCtrl.$scope.routeReady(route)
        else
          $bbPageCtrl.$scope.routeReady()
      return

    scrollAndFocusOnInvalid = () ->
      invalidFormGroup = elem.find('.has-error:first')

      if invalidFormGroup and invalidFormGroup.length > 0 and !scope.form.raise_alerts

        if 'parentIFrame' of $window
          parentIFrame.scrollToOffset(0, invalidFormGroup.offset().top - GeneralOptions.scroll_offset)
        else
          $bbug("html, body").animate
            scrollTop: invalidFormGroup.offset().top - GeneralOptions.scroll_offset
          , 1000

        invalidInput = invalidFormGroup.find('.ng-invalid')
        invalidInput.focus()
        return

    init()

    return

  return {
    restrict: 'A'
    require: ['^form', '?^^bbPage']
    scope: 'true'
    link: link
  }

angular.module('BB.Directives').directive 'bbForm', bbFormDirective