angular.module('BBAdmin.Controllers').controller('DashDayList', function ($scope,
                                                                          $rootScope, $q, BBModel) {

    let date;
    $scope.init = company_id => {
        $scope.inline_items = "";
        if (company_id) {
            $scope.bb.company_id = company_id;
        }
        if (!$scope.current_date) {
            $scope.current_date = moment().startOf('month');
        }
        date = $scope.current_date;
        let prms = {date: date.format('DD-MM-YYYY'), company_id: $scope.bb.company_id};
        if ($scope.service_id) {
            prms.service_id = $scope.service_id;
        }
        if ($scope.end_date) {
            prms.edate = $scope.end_date.format('DD-MM-YYYY');
        }

        // create a promise for the weeks and go get the days!
        let dayListDef = $q.defer();
        let weekListDef = $q.defer();
        $scope.dayList = dayListDef.promise;
        $scope.weeks = weekListDef.promise;
        prms.url = $scope.bb.api_url;

        return BBModel.Admin.Day.$query(prms).then(days => {
                $scope.sdays = days;
                dayListDef.resolve();
                if ($scope.category) {
                    return $scope.update_days();
                }
            }
        );
    };

    $scope.format_date = fmt => {
        return $scope.current_date.format(fmt);
    };

    $scope.selectDay = (day, dayBlock, e) => {
        if (day.spaces === 0) {
            return false;
        }
        let seldate = moment($scope.current_date);
        seldate.date(day.day);
        $scope.selected_date = seldate;

        let elm = angular.element(e.toElement);
        elm.parent().children().removeClass("selected");
        elm.addClass("selected");
        let xelm = $(`#tl_${$scope.bb.company_id}`);
        $scope.service_id = dayBlock.service_id;
        $scope.service = {id: dayBlock.service_id, name: dayBlock.name};
        $scope.selected_day = day;
        if (xelm.length === 0) {
            return $scope.inline_items = "/view/dash/time_small";
        } else {
            return xelm.scope().init(day);
        }
    };

    $scope.$watch('current_date', (newValue, oldValue) => {
            if (newValue && $scope.bb.company_id) {
                return $scope.init();
            }
        }
    );

    $scope.update_days = () => {
        $scope.dayList = [];
        $scope.service_id = null;

        return (() => {
            let result = [];
            for (let day of Array.from($scope.sdays)) {
                let item;
                if (day.category_id === $scope.category.id) {
                    $scope.dayList.push(day);
                    item = $scope.service_id = day.id;
                }
                result.push(item);
            }
            return result;
        })();
    };

    return $rootScope.$watch('category', (newValue, oldValue) => {
            if (newValue && $scope.sdays) {
                return $scope.update_days();
            }
        }
    );
});

