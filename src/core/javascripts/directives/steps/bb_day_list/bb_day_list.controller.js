angular.module('BB.Controllers').controller('DayList', function ($scope, $rootScope, $q, DayService) {

    // Load up some day based data
    $rootScope.connection_started.then(function () {
            if (!$scope.current_date && $scope.last_selected_date) {
                $scope.selected_date = $scope.last_selected_date.clone();
                setCurrentDate($scope.last_selected_date.clone().startOf('week'));
            } else if (!$scope.current_date) {
                setCurrentDate(moment().startOf('week'));
            }
            return $scope.loadData();
        }
        , err => $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong'));


    $scope.selectDay = day => {
        if (!day.spaces || (day.spaces && (day.spaces === 0))) {
            return;
        }
        $scope.setLastSelectedDate(day.date);
        $scope.selected_date = day.date;
        $scope.bb.current_item.setDate(day);
        return $scope.$broadcast('dateChanged', day.date);
    };


    var setCurrentDate = function (date) {
        $scope.current_date = date;
        return $scope.current_date_js = $scope.current_date.toDate();
    };


    $scope.add = (type, amount) => {
        setCurrentDate($scope.current_date.add(amount, type));
        return $scope.loadData();
    };


    $scope.subtract = (type, amount) => {
        return $scope.add(type, -amount);
    };


    $scope.currentDateChanged = function () {
        let date = moment($scope.current_date_js).startOf('week');
        setCurrentDate(date);
        return $scope.loadData();
    };


    // disable any day but monday
    $scope.isDateDisabled = function (date, mode) {
        date = moment(date);
        let result = (mode === 'day') && ((date.day() !== 1) || date.isBefore(moment(), 'day'));
        return result;
    };


    // calculate if the current earlist date is in the past - in which case we might want to disable going backwards
    $scope.isPast = () => {
        if (!$scope.current_date) {
            return true;
        }
        return moment().isAfter($scope.current_date);
    };


    return $scope.loadData = function () {
        $scope.day_data = {};
        $scope.notLoaded($scope);
        $scope.end_date = moment($scope.current_date).add(5, 'weeks');

        let promise = DayService.query({
            company: $scope.bb.company,
            cItem: $scope.bb.current_item,
            date: $scope.current_date.toISODate(),
            edate: $scope.end_date.toISODate(),
            client: $scope.client
        });

        return promise.then(function (days) {
                for (let day of Array.from(days)) {
                    $scope.day_data[day.string_date] = {spaces: day.spaces, date: day.date};
                }

                // group the day data by week
                $scope.weeks = _.groupBy($scope.day_data, day => day.date.week());
                $scope.weeks = _.toArray($scope.weeks);

                return $scope.setLoaded($scope);
            }

            , err => $scope.setLoadedAndShowError($scope, err, 'Sorry, something went wrong'));
    };
});
