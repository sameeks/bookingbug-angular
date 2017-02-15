// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BB.Directives').directive('bbQuestion', ($compile, $timeout) => {
        return {
            priority: 0,
            replace: true,
            transclude: false,
            restrict: 'A',
            compile(el, attr, trans) {
                return {
                    pre(scope, element, attrs) {
                        let adminRequired = (attrs.bbAdminRequired != null) ? true : false;

                        let date_format = 'DD/MM/YYYY';
                        let date_format_2 = 'dd/MM/yyyy';

                        if ((attrs.bbDateFormat != null) && (attrs.bbDateFormat === 'US')) {
                            date_format = 'MM/DD/YYYY';
                            date_format_2 = 'MM/dd/yyyy';
                        }

                        return scope.$watch(attrs.bbQuestion, function (question) {
                            if (question) {
                                let itemx, name;
                                let html = '';
                                let lastName = '';
                                let placeholder = '';

                                if (attrs.defaultPlaceholder != null) {
                                    if ((question.detail_type === "text_area") | (question.detail_type === "text_field")) {
                                        if (question.default) {
                                            placeholder = question.default;
                                        }
                                        if (question.answer === question.default) {
                                            question.answer = "";
                                        }
                                    }
                                }

                                scope.recalc = () => {
                                    if (angular.isDefined(scope.recalc_price)) {
                                        if (!question.outcome) {
                                            scope.recalc_price();
                                        }
                                    }
                                    if (angular.isDefined(scope.recalc_question)) {
                                        return scope.recalc_question();
                                    }
                                };

                                // are we using a completely custom question
                                if (scope.idmaps && (scope.idmaps[question.detail_type] || scope.idmaps[question.id])) {
                                    let index = scope.idmaps[scope.question.id] ? scope.question.id : scope.question.detail_type;
                                    ({html} = scope.idmaps[index]);

                                } else if ((question.detail_type === "select") || (question.detail_type === "select-price")) {
                                    html = `<select ng-model='question.answer' name='q${question.id}' id='${question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' class='form-question form-control'>`;
                                    for (itemx of Array.from(question.options)) {
                                        html += `<option data_id='${itemx.id}' value='${itemx.name.replace(/'/g, "&apos;")}'>${itemx.display_name}</option>`;
                                    }
                                    html += "</select>";

                                } else if (question.detail_type === "text_area") {
                                    html = `<textarea placeholder='${placeholder}' ng-model='question.answer' name='q${question.id}' id='${question.id}' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' rows=3 class='form-question form-control'>${question['answer']}</textarea>`;

                                } else if (question.detail_type === "radio") {
                                    html = '<div class="radio-group">';
                                    for (itemx of Array.from(question.options)) {
                                        html += `<div class='radio'><label class='radio-label'><input ng-model='question.answer' name='q${question.id}' id='${question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='radio' value=\"${itemx.name}\"/>${itemx.name}<span class='input-icon'></span></label></div>`;
                                    }
                                    html += "</div>";

                                } else if (question.detail_type === "check") {
                                    // stop the duplication of question names for muliple checkboxes by
                                    // checking the question name against the previous question name.
                                    ({name} = question);
                                    if (name === lastName) {
                                        name = "";
                                    }
                                    lastName = question.name;
                                    html = `<div class='checkbox' ng-class='{\"selected\": question.answer}'><label><input name='q${question.id}' id='${question.id}' ng-model='question.answer' ng-checked='question.answer == \"1\"' ng-change='recalc()' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='checkbox' value=1>${name}</label></div>`;

                                } else if (question.detail_type === "check-price") {
                                    html = `<div class='checkbox'><label><input name='q${question.id}' id='${question.id}' ng-model='question.answer' ng-checked='question.answer == \"1\"' ng-change='recalc()' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='checkbox' value=1> ({{question.price | currency:'GBP'}})</label></div>`;

                                } else if (question.detail_type === "radio-price") {
                                    html = '<div class="radio-group">';
                                    for (itemx of Array.from(question.options)) {
                                        html += `<div class='radio'><label class='radio-label'><input ng-model='question.answer' name='q${question.id}' id='${question.id}' ng-change='recalc()' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' type='radio' value=\"${itemx.name}\"/>${itemx.display_name}<span class='input-icon'></span></label></div>`;
                                    }
                                    html += "</div>";
                                } else if (question.detail_type === "date") {
                                    html = `\
<div class='input-group date-picker'> \
<input \
type='text' \
class='form-question form-control' \
name='q${question.id}' \
id='${question.id}' \
bb-datepicker-popup='${date_format}' \
uib-datepicker-popup='${date_format_2}' \
ng-change='recalc()' \
ng-model='question.answer' \
ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' \
datepicker-options='{\"starting-day\": 1, \"showButtonBar\": false, \"showWeeks\": false}' \
show-button-bar='false' \
is-open='opened' \
ng-focus='opened=true' /> \
<span class='input-group-btn' ng-click='$event.preventDefault();$event.stopPropagation();opened=true'> \
<button class='btn btn-default' type='submit'><span class='fa fa-calendar'></span></button> \
</span> \
</div>`;

                                } else {
                                    html = `<input type='text' placeholder='${placeholder}'  ng-model='question.answer' name='q${question.id}' id='${question.id}' ng-required='question.currentlyShown && ((${adminRequired} && question.required) || (question.required && !bb.isAdmin))' class='form-question form-control'/>`;
                                }

                                if (html) {
                                    let e;
                                    return e = $compile(html)(scope, (cloned, scope) => {
                                            return element.replaceWith(cloned);
                                        }
                                    );
                                }
                            }
                        });
                    }
                    ,
                    post(scope, $e, $a, parentControl) {
                    }
                };
            }
        };
    }
);
