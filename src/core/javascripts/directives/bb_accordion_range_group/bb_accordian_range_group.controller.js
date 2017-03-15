angular.module('BB.Controllers').controller('AccordionRangeGroup', function ($scope, $attrs, $rootScope, $q, FormDataStoreService, bbTimeZone, DateTimeUtilitiesService, $translate, CompanyStoreService) {

    $scope.$watch('slots', () => setData());

    $rootScope.connection_started.then(() => $scope.init());

    /***
     * @ngdoc method
     * @name init
     * @methodOf BB.Directives:bbAccordionRangeGroup
     * @description
     * Initialization of start time, end time and options
     *
     * @param {date} start_time The start time of the range group
     * @param {date} end_time The end time of the range group
     * @param {object} options The options of the range group
     */
    $scope.init = function () {

        $scope.start_time = $scope.options.range[0];
        $scope.end_time = $scope.options.range[1];

        $scope.options.collapse_when_time_selected = _.isBoolean($scope.options.collapse_when_time_selected) ? $scope.options.collapse_when_time_selected : true;
        $scope.options.hide_availability_summary = _.isBoolean($scope.options.hide_availability_summary) ? $scope.options.hide_availability_summary : false;

        $scope.heading = $translate.instant($scope.options.heading);

        return setData();
    };


    /***
     * @ngdoc method
     * @name setData
     * @methodOf BB.Directives:bbAccordionRangeGroup
     * @description
     * Set this data as ready
     */
    var setData = function () {

        $scope.accordion_slots = [];
        $scope.is_open = $scope.is_open || false;
        $scope.has_availability = $scope.has_availability || false;
        $scope.is_selected = $scope.is_selected || false;


        if ($scope.slots) {

            angular.forEach($scope.slots, function (slot) {


                // use display time zone to ensure slots get added to the correct range group
                let slot_time;
                if ((bbTimeZone.displayTimeZone != null) && (bbTimeZone.displayTimeZone !== CompanyStoreService.time_zone)) {
                    let datetime = moment(slot.datetime).tz(bbTimeZone.displayTimeZone);
                    slot_time = DateTimeUtilitiesService.convertMomentToTime(datetime);
                } else {
                    slot_time = slot.time;
                }

                if ((slot_time >= $scope.start_time) && (slot_time < $scope.end_time) && (slot.avail === 1)) {
                    return $scope.accordion_slots.push(slot);
                }
            });

            return updateAvailability();
        }
    };


    /***
     * @ngdoc method
     * @name updateAvailability
     * @methodOf BB.Directives:bbAccordionRangeGroup
     * @description
     * Update availability of the slot
     *
     * @param {date} day The day of range group
     * @param {string} slot The slot of range group
     */
    var updateAvailability = function (day, slot) {

        $scope.selected_slot = null;
        if ($scope.accordion_slots) {
            $scope.has_availability = hasAvailability();
        }

        if ($scope.disabled_slot && $scope.disabled_slot.time) {
            if ($scope.disabled_slot.date === $scope.day.date.toISODate()) {
                let relevent_slot;
                if (Array.isArray($scope.disabled_slot.time)) {
                    for (let times of Array.from($scope.disabled_slot.time)) {
                        times;
                        relevent_slot = _.findWhere($scope.slots, {time: times});
                        if (relevent_slot) {
                            relevent_slot.disabled = true;
                        }
                    }
                } else {
                    relevent_slot = _.findWhere($scope.slots, {time: $scope.disabled_slot.time});
                    if (relevent_slot) {
                        relevent_slot.disabled = true;
                    }
                }
            }
        }

        // if a day and slot has been provided, check if the slot is in range and mark it as selected
        if (day && slot) {

            // use display time zone to ensure slots get added to the right range group
            let slot_time;
            if ((bbTimeZone.displayTimeZone != null) && (bbTimeZone.displayTimeZone !== CompanyStoreService.time_zone)) {
                let datetime = moment(slot.datetime).tz(bbTimeZone.displayTimeZone);
                slot_time = DateTimeUtilitiesService.convertMomentToTime(datetime);
            } else {
                slot_time = slot.time;
            }

            if (day.date.isSame($scope.day.date, 'day') && (slot_time >= $scope.start_time) && (slot_time < $scope.end_time)) {
                $scope.selected_slot = slot;
            }

        } else {

            for (slot of Array.from($scope.accordion_slots)) {
                if (slot.selected) {
                    $scope.selected_slot = slot;
                    break;
                }
            }
        }

        if ($scope.selected_slot) {
            $scope.hideHeading = true;
            $scope.is_selected = true;
            if ($scope.options.collapse_when_time_selected) {
                return $scope.is_open = false;
            }
        } else {
            $scope.is_selected = false;
            if ($scope.options.collapse_when_time_selected) {
                return $scope.is_open = false;
            }
        }
    };


    /***
     * @ngdoc method
     * @name hasAvailability
     * @methodOf BB.Directives:bbAccordionRangeGroup
     * @description
     * Verify if availability of accordion slots have a slot
     */
    var hasAvailability = function () {
        if (!$scope.accordion_slots) {
            return false;
        }
        for (let slot of Array.from($scope.accordion_slots)) {
            if (slot.availability() > 0) {
                return true;
            }
        }
        return false;
    };


    return $scope.$on('slotChanged', function (event, day, slot) {
        if (day && slot) {
            return updateAvailability(day, slot);
        } else {
            return updateAvailability();
        }
    });
});
