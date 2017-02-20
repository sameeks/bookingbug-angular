angular.module('BB.Controllers').controller('GetAvailability', ($scope,
                                                                $element, $attrs, $rootScope, $q, TimeService, AlertService, BBModel,
                                                                halClient) =>

    /***
     * @ngdoc method
     * @name loadAvailability
     * @methodOf BB.Directives:bbGetAvailability
     * @description
     * Load availability of the services in according of prms parameter
     *
     * @param {array} prms The parameters of availability
     */
    $scope.loadAvailability = prms => {

        let service = halClient.$get($scope.bb.api_url + '/api/v1/' + prms.company_id + '/services/' + prms.service);
        return service.then(serv => {
                $scope.earliest_day = null;
                let sday = moment();
                let eday = moment().add(30, 'days');
                return serv.$get('days', {date: sday.toISOString(), edate: eday.toISOString()}).then(res =>
                    (() => {
                        let result = [];
                        for (let day of Array.from(res.days)) {
                            let item;
                            if ((day.spaces > 0) && !$scope.earliest_day) {
                                $scope.earliest_day = moment(day.date);
                                if (day.first) {
                                    item = $scope.earliest_day.add(day.first, "minutes");
                                }
                            }
                            result.push(item);
                        }
                        return result;
                    })()
                );
            }
        );
    }
);
