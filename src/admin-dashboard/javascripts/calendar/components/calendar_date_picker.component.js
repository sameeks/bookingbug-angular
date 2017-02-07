'use strict';

angular
    .module('BBAdminDashboard.calendar.directives')
    .component('bbCalendarDatePicker', {
        templateUrl: 'calendar/bb_calendar_date_picker.html',
        bindings: {
            onChangeDate: '&',
            currentDate: '<'
        },
        controller: CalendarDatePickerCtrl,
        controllerAs: '$bbCalendarDatePickerCtrl'
    });

var CalendarDatePickerCtrl = function() {
    'ngInject';

    var ctrl = this;

    ctrl.openDatePicker = function($event) {
        $event.preventDefault();
        ctrl.datePickerOpened = true;
    };

    ctrl.datePickerUpdated = function() {
        if (_.isDate(ctrl.currentDate)) {
            ctrl.onChangeDate({
                $event: {
                    date: ctrl.currentDate
                }
            });
        }
    };

};
