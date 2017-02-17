angular.module('BB.Directives').directive('bbAdminCalendar', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: 'BBAdminCalendarCtrl'
        }
    }
);

let BBAdminCalendarCtrl = function ($scope, $element, $controller, $attrs, BBModel, $rootScope) {

    angular.extend(this, $controller('TimeList', {
        $scope,
        $attrs,
        $element
    }));

    $scope.calendar_view = {
        next_available: false,
        day: false,
        multi_day: false
    };

    $rootScope.connection_started.then(() => $scope.initialise());

    $scope.initialise = function () {
        // set default view
        if ($scope.bb.item_defaults.pick_first_time) {
            $scope.switchView('next_available');
        } else if ($scope.bb.current_item.defaults.time != null) {
            $scope.switchView('day');
        } else {
            $scope.switchView($scope.bb.item_defaults.day_view || 'multi_day');
        }

        if ($scope.bb.current_item.person) {
            $scope.person_name = $scope.bb.current_item.person.name;
        }
        if ($scope.bb.current_item.resource) {
            return $scope.resource_name = $scope.bb.current_item.resource.name;
        }
    };


    $scope.switchView = function (view) {

        if (view === "day") {
            if ($scope.slots && $scope.bb.current_item.time) {
                for (let slot of Array.from($scope.slots)) {
                    if (slot.time === $scope.bb.current_item.time.time) {
                        $scope.highlightSlot(slot, $scope.bb.current_item.date);
                        break;
                    }
                }
            }
        }

        // reset views
        for (let key in $scope.calendar_view) {
            let value = $scope.calendar_view[key];
            $scope.calendar_view[key] = false;
        }

        // set new view
        return $scope.calendar_view[view] = true;
    };


    $scope.pickTime = function (slot) {
        $scope.bb.current_item.setDate({date: slot.datetime});
        $scope.bb.current_item.setTime(slot);

        $scope.setLastSelectedDate(slot.datetime);

        if ($scope.bb.current_item.reserve_ready) {
            return $scope.addItemToBasket().then(() => {
                    return $scope.decideNextPage();
                }
            );
        } else {
            return $scope.decideNextPage();
        }
    };

    $scope.pickOtherTime = () => $scope.availability_conflict = false;

    $scope.setCloseBookings = bookings => $scope.other_bookings = bookings;


    return $scope.overBook = function () {

        let new_timeslot = new BBModel.TimeSlot({time: $scope.bb.current_item.defaults.time, avail: 1});
        let new_day = new BBModel.Day({date: $scope.bb.current_item.defaults.datetime, spaces: 1});

        $scope.setLastSelectedDate(new_day.date);
        $scope.bb.current_item.setDate(new_day);

        $scope.bb.current_item.setTime(new_timeslot);

        $scope.bb.current_item.setPerson($scope.bb.current_item.defaults.person);
        $scope.bb.current_item.setResource($scope.bb.current_item.defaults.resource);

        if ($scope.bb.current_item.reserve_ready) {
            return $scope.addItemToBasket().then(() => {
                    return $scope.decideNextPage();
                }
            );
        } else {
            return $scope.decideNextPage();
        }
    };
};

angular.module('BB.Controllers').controller('BBAdminCalendarCtrl', BBAdminCalendarCtrl);

angular.module('BB.Directives').directive('bbAdminCalendarConflict', () => {
        return {
            restrict: 'AE',
            replace: true,
            scope: true,
            controller: BBAdminCalendarConflictCtrl
        };
    }
);

var BBAdminCalendarConflictCtrl = function ($scope, $element, $controller, $attrs, BBModel) {
    'ngInject';

    let {time} = $scope.bb.current_item.defaults;
    let {duration} = $scope.bb.current_item;
    let end_time = time + $scope.bb.current_item.duration;

    let start_datetime = $scope.bb.current_item.defaults.datetime;

    // caclulate the max and min time we need to book around based on the service pre and post time
    let {service} = $scope.bb.current_item;
    let min_time = start_datetime.clone().add(-(service.pre_time || 0), 'minutes');
    let max_time = start_datetime.clone().add(duration + (service.post_time || 0), 'minutes');

    let st = time - 30;
    let en = time + duration + 30;

    let ibest_earlier = 0;
    let ibest_later = 0;

    $scope.allow_overbook = $scope.bb.company.settings.has_overbook;

    if ($scope.slots) {
        for (let slot of Array.from($scope.slots)) {
            if (time > slot.time) {
                ibest_earlier = slot.time;
                $scope.best_earlier = slot;
            }
            if ((ibest_later === 0) && (slot.time > time)) {
                ibest_later = slot.time;
                $scope.best_later = slot;
            }
        }
    }

    // I actaully think this time is available - just it's not on a schedule step that matches
    if ((ibest_earlier > 0) && (ibest_later > 0) && (ibest_earlier > (time - duration)) && (ibest_later < (time + duration))) {
        $scope.step_mismatch = true;
    }

    $scope.checking_conflicts = true;

    /**
     * @returns {Number}
     */
    let getCurrentPersonId = function () {
        if ($scope.bb.current_item.person != null) {
            return $scope.bb.current_item.person.id;
        }
        if ($scope.bb.current_item.defaults.person != null) {
            return $scope.bb.current_item.defaults.person.id;
        }
    };

    let params = {
        src: $scope.bb.company,
        person_id: getCurrentPersonId(),
        resource_id: $scope.bb.current_item.defaults.resource ? $scope.bb.current_item.defaults.resource_id : undefined,
        start_date: $scope.bb.current_item.defaults.datetime.format('YYYY-MM-DD'),
        start_time: sprintf("%02d:%02d", st / 60, st % 60),
        end_time: sprintf("%02d:%02d", en / 60, en % 60)
    };

    BBModel.Admin.Booking.$query(params).then(function (bookings) {
            if (bookings.items.length > 0) {
                $scope.nearby_bookings = _.filter(bookings.items, x => ($scope.bb.current_item.defaults.person && (x.person_id === $scope.bb.current_item.defaults.person.id)) || ($scope.bb.current_item.defaults.resources && (x.resources_id === $scope.bb.current_item.defaults.resources.id)));
                $scope.overlapping_bookings = _.filter($scope.nearby_bookings, function (x) {
                    let b_st = moment(x.datetime).subtract(-(x.pre_time || 0), "minutes");
                    let b_en = moment(x.end_datetime).subtract((x.post_time || 0), "minutes");
                    return (b_st.isBefore(max_time)) && (b_en.isAfter(min_time));
                });
                if ($scope.nearby_bookings.length === 0) {
                    $scope.nearby_bookings = false;
                }
                if ($scope.overlapping_bookings.length === 0) {
                    $scope.overlapping_bookings = false;
                }
            }

            if (!$scope.overlapping_bookings && $scope.bb.company.$has('external_bookings')) { // no overlappying bookings - try external bookings
                params = {
                    start: $scope.bb.current_item.defaults.datetime.format('YYYY-MM-DD'),
                    end: $scope.bb.current_item.defaults.datetime.clone().add(1, 'day').format('YYYY-MM-DD'),
                    person_id: $scope.bb.current_item.defaults.person ? $scope.bb.current_item.defaults.person.id : undefined,
                    resource_id: $scope.bb.current_item.defaults.resource ? $scope.bb.current_item.defaults.resource_id : undefined
                };
                $scope.bb.company.$get('external_bookings', params).then(function (collection) {
                    bookings = collection.external_bookings;
                    if (bookings && (bookings.length > 0)) {
                        return $scope.external_bookings = _.filter(bookings, function (x) {
                            x.start_time = moment(x.start);
                            x.end_time = moment(x.end);
                            if (!x.title) {
                                x.title = "Blocked";
                            }
                            return (x.start_time.isBefore(max_time)) && (x.end_time.isAfter(min_time));
                        });
                    }
                });
            }

            return $scope.checking_conflicts = false;
        }
        , err => $scope.checking_conflicts = false);

};
