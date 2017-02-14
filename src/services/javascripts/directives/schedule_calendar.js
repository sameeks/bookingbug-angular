// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdminServices').directive('scheduleCalendar', function (uiCalendarConfig, ScheduleRules) {

    let controller = function ($scope, $attrs) {

        $scope.calendarName = 'scheduleCal';

        $scope.eventSources = [{
            events(start, end, timezone, callback) {
                return callback($scope.getEvents());
            }
        }
        ];

        $scope.getCalendarEvents = function (start, end) {
            let events;
            return events = uiCalendarConfig.calendars.scheduleCal.fullCalendar('clientEvents',
                e =>
                (start.isAfter(e.start) || start.isSame(e.start)) &&
                (end.isBefore(e.end) || end.isSame(e.end)));
        };

        let options = $scope.setOptions;
        if (!options) {
            options = {};
        }

        $scope.options = {
            calendar: {
                schedulerLicenseKey: '0598149132-fcs-1443104297',
                height: options.height || "auto",
                editable: false,
                selectable: true,
                defaultView: 'agendaWeek',
                header: {
                    left: 'today,prev,next',
                    center: 'title',
                    right: 'month,agendaWeek'
                },
                selectHelper: false,
                eventOverlap: false,
                lazyFetching: false,
                views: {
                    agendaWeek: {
                        duration: {
                            weeks: 1
                        },
                        allDaySlot: false,
                        slotEventOverlap: false,
                        minTime: options.min_time || '00:00:00',
                        maxTime: options.max_time || '24:00:00'
                    }
                },
                select(start, end, jsEvent, view) {
                    let events = $scope.getCalendarEvents(start, end);
                    if (events.length > 0) {
                        return $scope.removeRange(start, end);
                    } else {
                        return $scope.addRange(start, end);
                    }
                },
                eventResizeStop(event, jsEvent, ui, view) {
                    return $scope.addRange(event.start, event.end);
                },
                eventDrop(event, delta, revertFunc, jsEvent, ui, view) {
                    if (event.start.hasTime()) {
                        let orig = {
                            start: moment(event.start).subtract(delta),
                            end: moment(event.end).subtract(delta)
                        };
                        $scope.removeRange(orig.start, orig.end);
                        return $scope.addRange(event.start, event.end);
                    }
                },
                eventClick(event, jsEvent, view) {
                    return $scope.removeRange(event.start, event.end);
                }
            }
        };

        return $scope.render = () => uiCalendarConfig.calendars.scheduleCal.fullCalendar('render');
    };


    let link = function (scope, element, attrs, ngModel) {

        let scheduleRules = () => new ScheduleRules(ngModel.$viewValue);

        scope.getEvents = () => scheduleRules().toEvents();

        scope.addRange = function (start, end) {
            ngModel.$setViewValue(scheduleRules().addRange(start, end));
            return ngModel.$render();
        };

        scope.removeRange = function (start, end) {
            ngModel.$setViewValue(scheduleRules().removeRange(start, end));
            return ngModel.$render();
        };

        scope.toggleRange = function (start, end) {
            ngModel.$setViewValue(scheduleRules().toggleRange(start, end));
            return ngModel.$render();
        };

        return ngModel.$render = function () {
            if (uiCalendarConfig && uiCalendarConfig.calendars.scheduleCal) {
                uiCalendarConfig.calendars.scheduleCal.fullCalendar('refetchEvents');
                return uiCalendarConfig.calendars.scheduleCal.fullCalendar('unselect');
            }
        };
    };

    return {
        controller,
        link,
        templateUrl: 'schedule_cal_main.html',
        require: 'ngModel',
        scope: {
            render: '=?',
            setOptions: '=options'
        }
    };
});

