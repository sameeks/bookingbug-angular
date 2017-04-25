(function () {

    /**
     * @ngdoc service
     * @name BBAdminDashboard.CheckInService
     *
     * @description
     * Responsible for getting check-in data
     *
    */

    angular
        .module('BBAdminDashboard')
        .factory('CheckInService', checkInService);

    function checkInService($q, BBModel, $rootScope) {
        return {
            /***
             * @ngdoc method
             * @name getAppointments
             * @methodOf BBAdminDashboard.CheckInService
             * @description
             * Get the current dates bookings
             * @param {integer} current_page The current pagination page
             *
            */
            getAppointments(current_page, filter_by, filter_by_fields, order_by, order_by_reverse, skip_cache) {
                const date = moment().format('YYYY-MM-DD');
                const company = $rootScope.bb.company;
                const url = $rootScope.bb.api_url;

                const params = {
                    company,
                    date,
                    url,
                    current_page,
                    filter_by,
                    filter_by_fields,
                    order_by,
                    order_by_reverse,
                    skip_cache
                };

                this.queryAdminBookings(params);
            },

            /***
             * @ngdoc method
             * @name queryAdminBooking
             * @methodOf BBAdminDashboard.CheckInService
             * @description
             * Queries admin booking endpoint for the current dates bookings
             * @params {object} params The params to query for bookings
             *
            */
            queryAdminBookings(params) {
                let defer = $q.defer();
                BBModel.Admin.Booking.$query(params).then(res => {
                    this.booking_collection = res;
                    this.bookings = [];
                    this.bmap = {};
                    for (var item of Array.from(res.items)) {
                        if (item.status !== 3) { // not blocked
                            this.bookings.push(item.id);
                            this.bmap[item.id] = item;
                        }
                    }
                    $rootScope.$broadcast('checkIn:dataRecieved', Array.from(res.items));

                    // update the items if they've changed
                    this.booking_collection.addCallback(this, (booking, status) => {
                        this.handleBookingChanges(booking, status);
                    });

                    return defer.resolve(this.bookings);
                }
                , err => defer.reject(err));
                return defer.promise;
            },


            handleBookingChanges(booking, status) {
                this.bookings = [];
                this.bmap = {};
                return (() => {
                    let result = [];
                    for (let item of Array.from(this.booking_collection.items)) {
                        let item1;
                        if (item.status !== 3) { // not blocked
                            this.bookings.push(item.id);
                            item1 = this.bmap[item.id] = item;
                        }
                        result.push(item1);
                    }
                    return result;
                })();
            }
        };
    }
})();

