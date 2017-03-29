/***
 * @ngdoc service
 * @name BB.Services:DateTimeUtilities
 *
 * @description
 * Service for manipulating datetime objects
 *
 *///

angular.module('BB.Services').factory("DateTimeUtilitiesService", function (GeneralOptions, CompanyStoreService, bbTimeZone) {


    /***
     * @ngdoc method
     * @name checkPerson
     * @methodOf BB.Services:DateTimeUtilities
     * @description
     * Checks if basket_item has default person
     * @param {Object} basket_item The basket item object
     * @param {Object} item_defaults The item defaults object
     *
     * @returns {boolean}
     */
    let checkPerson = (basket_item, item_defaults) => (basket_item.defaults.person && (basket_item.defaults.person.self === basket_item.person.self)) || _.isBoolean(basket_item.person) || item_defaults.merge_people;

    /***
     * @ngdoc method
     * @name checkResource
     * @methodOf BB.Services:DateTimeUtilities
     * @description
     * Checks if basket_item has default resource
     * @param {Object} basket_item The basket item object
     * @param {Object} item_defaults The item defaults object
     *
     * @returns {boolean}
     */
    let checkResource = (basket_item, item_defaults) => (basket_item.defaults.resource && (basket_item.defaults.resource.self === basket_item.resource.self)) || _.isBoolean(basket_item.resource) || item_defaults.merge_resources;


    return {
        /***
         * @ngdoc method
         * @name convertTimeToMoment
         * @methodOf BB.Services:DateTimeUtilities
         * @description
         * Converts date and time to valid moment object
         * @param {Moment} date The date object to convert
         * @param {integer} time The time integer to convert
         *
         * @returns {object} Moment object converted from date/time
         */
        convertTimeToMoment(date, time) {
            if (!date || !moment.isMoment(date) || !angular.isNumber(time)) {
                return;
            }
            let datetime = moment();
            // if user timezone different than company timezone
            /*if (bbTimeZone.isCustomTimeZone()) {
                datetime = datetime.tz(CompanyStoreService.time_zone);
            }*////TODO double check

            datetime = bbTimeZone.convertToCompanyTz(datetime);

            let val = parseInt(time);
            let hours = parseInt(val / 60);
            let mins = val % 60;
            datetime.hour(hours);
            datetime.minutes(mins);
            datetime.seconds(0);
            datetime.date(date.date());
            datetime.month(date.month());
            datetime.year(date.year());

            return datetime;
        },


        /***
         * @ngdoc method
         * @name convertMomentToTime
         * @methodOf BB.Services:DateTimeUtilities
         * @description
         * Converts moment object to time
         * @param {Moment} datetime the datetime object to convert
         *
         * @returns {integer} Datetime integer converted from moment object
         */
        convertMomentToTime(datetime) {
            return datetime.minutes() + (datetime.hours() * 60);
        },


        /***
         * @ngdoc method
         * @name checkDefaultTime
         * @methodOf BB.Services:DateTimeUtilities
         * @description
         *  Checks if basket_item default time exists
         * @param {Moment} date The date object
         * @param {Array} time_slots An array of time slots
         * @param {Object} basket_item The basket item object
         * @param {Object} item_defaults The item defaults object
         * @returns {Object} object describing matching slot
         */
        checkDefaultTime(date, time_slots, basket_item, item_defaults) {
            let match, slot;
            if (!basket_item.defaults.time) {
                match = null;
            } else if (checkPerson(basket_item, item_defaults) && checkResource(basket_item, item_defaults)) {
                match = "full";
            } else {
                match = "partial";
            }

            let found_time_slot = null;

            if (basket_item.defaults.time && ((basket_item.defaults.date && date.isSame(basket_item.defaults.date, 'day')) || !basket_item.defaults.date)) {

                let time = basket_item.time ? basket_item.time.time : basket_item.defaults.time;

                for (slot of Array.from(time_slots)) {
                    if (time && (time === slot.time) && (slot.avail === 1)) {
                        found_time_slot = slot;
                        break;
                    }
                }
            }

            return {
                match,
                slot: found_time_slot
            };
        }
    };
});
