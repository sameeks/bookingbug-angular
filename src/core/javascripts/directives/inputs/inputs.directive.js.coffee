'use strict'

# Directives
app = angular.module 'BB.Directives'


# Min/Max directives for use with number inputs
# Although angular provides min/max directives when using a HTML number input, the control does not validate if the field is actually a number
# so we have to use a text input with a ng-pattern that only allows numbers.
# http://jsfiddle.net/g/s5gKC/

isEmpty = (value) ->
  angular.isUndefined(value) or value is "" or value is null or value isnt value


app.directive 'bbQuestionLabel', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: false,
  link: (scope, element, attrs) ->
    scope.$watch attrs.bbQuestionLabel, (question) ->
      if question
        if question.detail_type == "check" || question.detail_type == "check-price"
          element.html("")


app.directive 'bbQuestionLink', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: true,
  link: (scope, element, attrs) ->
    id = parseInt(attrs.bbQuestionLink)
    scope.$watch "question_set", (newval, oldval) ->
      if newval
        for q in scope.question_set
          if q.id == id
            scope.question = q
            element.attr('ng-model',"question.answer")
            element.attr('bb-question-link',null)
            $compile(element)(scope)


app.directive 'bbQuestionSet', ($compile) ->
  transclude: false,
  restrict: 'A',
  scope: true,
  link: (scope, element, attrs) ->
    set = attrs.bbQuestionSet
    element.addClass 'ng-hide'
    scope.$watch set, (newval, oldval) ->
      if newval
        scope.question_set = newval
        element.removeClass 'ng-hide'


# Input match test
app.directive "bbMatchInput", ->
  restrict: "A"
  require: 'ngModel'
  link: (scope, element, attrs, ctrl, ngModel) ->

    scope.$watch attrs.bbMatchInput, ->
      scope.val_1 = scope.$eval(attrs.bbMatchInput)
      compare(ctrl.$viewValue)

    compare = (value) ->
      ctrl.$setValidity 'match', scope.val_1 == value
      value

    ctrl.$parsers.push compare
