'use strict'

# bbDateSplit
angular.module('BB.Directives').directive 'bbDateSplit', ($parse) ->
  restrict: 'A'
  require: ['ngModel']
  link: (scope, element, attrs, ctrls) ->

    ngModel = ctrls[0]

    question = scope.$eval attrs.bbDateSplit

    question.date = {
      day:   null
      month: null
      year:  null
      date:  null

      joinDate:  ->
        if @day && @month && @year
          date_string = @day + '/' + @month + '/' + @year
          @date = moment(date_string, "DD/MM/YYYY")
          date_string = @date.toISODate()

          ngModel.$setViewValue(date_string)
          ngModel.$render()

      splitDate: (date) ->
        if date && date.isValid()
          @day   = date.date()
          @month = date.month() + 1
          @year  = date.year()
          @date  = date
    }

    # split the date if it's already set
    question.date.splitDate(moment(question.answer)) if question.answer
    question.date.splitDate(moment(ngModel.$viewValue)) if ngModel.$viewValue

    # watch self to split date when it changes
    # scope.$watch attrs.ngModel, (newval) ->
    #   if newval
    #     new_date = moment(newval)
    #     if !new_date.isSame(question.date)
    #        question.date.splitDate(new_date)
