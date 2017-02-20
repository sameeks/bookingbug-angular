/***
 * @ngdoc service
 * @name BB.Models:Service
 *
 * @description
 * Representation of an Service Object
 *
 * @property {integer} id Id of the service
 * @property {string} name The name of service
 * @property {date} duration Duration of the service
 * @property {float} prices The prices of the service
 * @property {integer} detail_group_id The detail group id
 * @property {date} booking_time_step The time step of the booking
 * @property {integer} min_bookings The minimum number of bookings
 * @property {integer} max_booings The maximum number of bookings
 */


angular.module('BB.Models').factory("ServiceModel", ($q, BBModel, BaseModel, ServiceService) =>

    class Service extends BaseModel {

        constructor(data) {
            super(...arguments);
            if (this.prices && (this.prices.length > 0)) {
                this.price = this.prices[0];
            }
            if (this.durations && (this.durations.length > 0)) {
                this.duration = this.durations[0];
            }
            if (!this.listed_durations) {
                this.listed_durations = this.durations;
            }
            if (this.listed_durations && (this.listed_durations.length > 0)) {
                this.listed_duration = this.listed_durations[0];
            }

            this.min_advance_datetime = moment().add(this.min_advance_period, 'seconds');
            this.max_advance_datetime = moment().add(this.max_advance_period, 'seconds');
        }

        /***
         * @ngdoc method
         * @name getPriceByDuration
         * @methodOf BB.Models:Service
         * @description
         * Get price by duration in function of duration
         *
         * @returns {object} The returning price by duration
         */
        getPriceByDuration(dur) {
            for (let i = 0; i < this.durations.length; i++) {
                let d = this.durations[i];
                if (d === dur) {
                    return this.prices[i];
                }
            }
        }

        // return price

        /***
         * @ngdoc method
         * @name $getCategory
         * @methodOf BB.Models:Service
         * @description
         * Get category promise
         *
         * @returns {object} The returning category promise
         */
        $getCategory() {
            if (!this.$has('category')) {
                return null;
            }
            let prom = this.$get('category');
            prom.then(cat => {
                    return this.category = new BBModel.Category(cat);
                }
            );
            return prom;
        }

        /***
         * @ngdoc method
         * @name days_array
         * @methodOf BB.Models:Service
         * @description
         * Put days in array
         *
         * @returns {array} The returning days array
         */
        days_array() {
            let arr = [];
            for (let x = this.min_bookings, end = this.max_bookings, asc = this.min_bookings <= end; asc ? x <= end : x >= end; asc ? x++ : x--) {
                let str = `${x} day`;
                if (x > 1) {
                    str += "s";
                }
                arr.push({name: str, val: x});
            }
            return arr;
        }


        /***
         * @ngdoc method
         * @name $query
         * @methodOf BB.Models:Service
         * @description
         * Static function that loads an array of services from a company object
         *
         * @returns {promise} A returned promise
         */
        static $query(company) {
            return ServiceService.query(company);
        }
    }
);

