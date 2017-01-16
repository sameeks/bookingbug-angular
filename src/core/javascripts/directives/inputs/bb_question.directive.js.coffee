'use strict'

angular.module('BB.Directives').directive 'bbQuestion', ($compile, $timeout) ->
  priority: 0,
  replace: true,
  transclude: false,
  restrict: 'A',
  compile: (el,attr,trans) ->
      pre: (scope, element, attrs) ->
        adminRequired = if attrs.bbAdminRequired? then true else false

        date_format = 'DD/MM/YYYY'
        date_format_2 = 'dd/MM/yyyy'

        if attrs.bbDateFormat? && attrs.bbDateFormat is 'US'
          date_format = 'MM/DD/YYYY'
          date_format_2 = 'MM/dd/yyyy'

        scope.$watch attrs.bbQuestion, (question) ->
          if question
            html = ''
            lastName = ''
            placeholder = ''

            if attrs.defaultPlaceholder?
              if question.detail_type is "text_area" | question.detail_type is "text_field"
                placeholder = question.default if question.default
                if question.answer == question.default
                  question.answer = ""

            scope.recalc = () =>
              if angular.isDefined(scope.recalc_price)
                scope.recalc_price() if !question.outcome
              if angular.isDefined(scope.recalc_question)
                scope.recalc_question()

            # are we using a completely custom question
            if scope.idmaps and (scope.idmaps[question.detail_type] or scope.idmaps[question.id])
              index = if scope.idmaps[scope.question.id] then scope.question.id else scope.question.detail_type
              html = scope.idmaps[index].html

            else if question.detail_type is "select" || question.detail_type is "select-price"
              html = "<select ng-model='question.answer' name='q#{question.id}' id='#{question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' class='form-question form-control'>"
              for itemx in question.options
                html += "<option data_id='#{itemx.id}' value='#{itemx.name.replace(/'/g, "&apos;")}'>#{itemx.display_name}</option>"
              html += "</select>"

            else if question.detail_type is "text_area"
              html = "<textarea placeholder='#{placeholder}' ng-model='question.answer' name='q#{question.id}' id='#{question.id}' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' rows=3 class='form-question form-control'>#{question['answer']}</textarea>"

            else if question.detail_type is "radio"
              html = '<div class="radio-group">'
              for itemx in question.options
                html += "<div class='radio'><label class='radio-label'><input ng-model='question.answer' name='q#{question.id}' id='#{question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='radio' value=\"#{itemx.name}\"/>#{itemx.name}<span class='input-icon'></span></label></div>"
              html += "</div>"

            else if question.detail_type is "check"
              # stop the duplication of question names for muliple checkboxes by
              # checking the question name against the previous question name.
              name = question.name
              if name is lastName
                name = ""
              lastName = question.name
              html = "<div class='checkbox' ng-class='{\"selected\": question.answer}'><label><input name='q#{question.id}' id='#{question.id}' ng-model='question.answer' ng-checked='question.answer == \"1\"' ng-change='recalc()' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='checkbox' value=1>#{name}</label></div>"

            else if question.detail_type is "check-price"
              html = "<div class='checkbox'><label><input name='q#{question.id}' id='#{question.id}' ng-model='question.answer' ng-checked='question.answer == \"1\"' ng-change='recalc()' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='checkbox' value=1> ({{question.price | currency:'GBP'}})</label></div>"

            else if question.detail_type is "radio-price"
              html = '<div class="radio-group">'
              for itemx in question.options
                html += "<div class='radio'><label class='radio-label'><input ng-model='question.answer' name='q#{question.id}' id='#{question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='radio' value=\"#{itemx.name}\"/>#{itemx.display_name}<span class='input-icon'></span></label></div>"
              html += "</div>"
            else if question.detail_type is "date"
              html = "
                <div class='input-group date-picker'>
                  <input
                    type='text'
                    class='form-question form-control'
                    name='q#{question.id}'
                    id='#{question.id}'
                    bb-datepicker-popup='#{date_format}'
                    uib-datepicker-popup='#{date_format_2}'
                    ng-change='recalc()'
                    ng-model='question.answer'
                    ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))'
                    datepicker-options='{\"starting-day\": 1, \"showButtonBar\": false, \"showWeeks\": false}'
                    show-button-bar='false'
                    is-open='opened'
                    ng-focus='opened=true' />
                  <span class='input-group-btn' ng-click='$event.preventDefault();$event.stopPropagation();opened=true'>
                    <button class='btn btn-default' type='submit'><span class='glyphicon glyphicon-calendar'></span></button>
                  </span>
                </div>"

            else
              html = "<input type='text' placeholder='#{placeholder}'  ng-model='question.answer' name='q#{question.id}' id='#{question.id}' ng-required='question.currentlyShown && ((#{adminRequired} && question.required) || (question.required && !bb.isAdmin))' class='form-question form-control'/>"

            if html
              e = $compile(html) scope, (cloned, scope) =>
                element.replaceWith(cloned)
      ,
      post: (scope, $e, $a, parentControl) ->
