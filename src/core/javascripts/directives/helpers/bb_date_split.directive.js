// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
// bbDateSplit
angular.module('BB.Directives').directive('bbDateSplit', $parse =>
    ({
        restrict: 'A',
        require: ['ngModel'],
        link(scope, element, attrs, ctrls) {

            let ngModel = ctrls[0];

            let question = scope.$eval(attrs.bbDateSplit);

            question.date = {
                day: null,
                month: null,
                year: null,
                date: null,

                joinDate() {
                    if (this.day && this.month && this.year) {
                        let date_string = this.day + '/' + this.month + '/' + this.year;
                        this.date = moment(date_string, "DD/MM/YYYY");
                        date_string = this.date.toISODate();

                        ngModel.$setViewValue(date_string);
                        return ngModel.$render();
                    }
                },

                splitDate(date) {
                    if (date && date.isValid()) {
                        this.day = date.date();
                        this.month = date.month() + 1;
                        this.year = date.year();
                        return this.date = date;
                    }
                }
            };

            // split the date if it's already set
            if (question.answer) {
                question.date.splitDate(moment(question.answer));
            }
            if (ngModel.$viewValue) {
                return question.date.splitDate(moment(ngModel.$viewValue));
            }
        }
    })
);

// watch self to split date when it changes
// scope.$watch attrs.ngModel, (newval) ->
//   if newval
//     new_date = moment(newval)
//     if !new_date.isSame(question.date)
//        question.date.splitDate(new_date)
