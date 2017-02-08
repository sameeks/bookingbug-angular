(function () {

    'use strict';

    var calendarDatePickerComponent = {
        templateUrl: 'calendar/bb_calendar_date_picker.html',
        bindings: {
            onChangeDate: '&',
            currentDate: '<'
        },
        controller: CalendarDatePickerCtrl,
        controllerAs: '$bbCalendarDatePickerCtrl'
    };

    function CalendarDatePickerCtrl () {
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
    }

    angular
        .module('BBAdminDashboard.calendar.directives')
        .component('bbCalendarDatePicker', calendarDatePickerComponent);

})();
