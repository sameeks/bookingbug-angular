(function () {

    /**
     * @ngdoc service
     * @name BBAdminDashboard.bbTimeZoneOptions
     * @description
     * TimeZone options factory
     */
    angular
        .module('BB.i18n')
        .factory('bbTimeZoneOptions', timeZoneOptionsService);

    function timeZoneOptionsService($translate, orderByFilter, bbCustomTimeZones, bbTimeZone) {

        return {
            generateTimeZoneList
        };

        /**
         * @ngdoc function
         * @name generateTimeZoneList
         * @methodOf BBAdminDashboard.Services:TimeZoneOptions
         * @param {Boolean} momentNames
         * @param {String, Array} limitTo - limit time zones to a specific region (String) or multiple regions (Array)
         * @param {String, Array} exclude - exclude time zones from generated list
         * @param {String} format
         * @returns {Array} A list of time zones
         */
        function generateTimeZoneList(useMomentNames, limitTimeZones, excludeTimeZones, format) {
            let timeZones = [];

            let timeZoneNames = loadTimeZones(useMomentNames, limitTimeZones, excludeTimeZones);
            for (let [index, value] of timeZoneNames.entries()) {
                timeZones.push(mapTimeZoneItem(value, index, format, useMomentNames));
            }

            timeZones = _.uniq(timeZones, (timeZone) => timeZone.display);
            timeZones = orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timeZones;
        }

        function loadTimeZones(useMomentNames, limitTimeZones, excludeTimeZones) {
            let timeZoneNames = [];

            if (useMomentNames) {
                timeZoneNames = moment.tz.names();
                timeZoneNames = _.chain(timeZoneNames)
                    .filter((tz) => tz.indexOf('GMT') === -1)
                    .filter((tz) => tz.indexOf('Etc') === -1)
                    .filter((tz) => tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase())
                    .value();
            } else {
                timeZoneNames = Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES);
            }

            if (limitTimeZones) timeZoneNames = updateTimeZoneNames(timeZoneNames, limitTimeZones);
            if (excludeTimeZones) timeZoneNames = updateTimeZoneNames(timeZoneNames, excludeTimeZones, true);

            return timeZoneNames;
        }

        function updateTimeZoneNames(timeZones, timeZone, exclude) {

            if (angular.isString(timeZone)) {
                return timeZoneFilter(timeZone);
            }

            if (angular.isArray(timeZone)) {
                let locations = [];
                _.each(timeZone, (region) => locations.push(timeZoneFilter(region)));
                return _.flatten(locations);
            }

            function timeZoneFilter(filterBy) {
                if (exclude) {
                    return _.reject(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                } else {
                    return _.filter(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                }
            }
        }

        function mapTimeZoneItem(location, index, format, momentNames) {
            const timeZone = {};

            const city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            const momentTz = moment.tz(location);

            timeZone.display = formatDisplayValue(city, momentTz, format, momentNames);
            timeZone.value = location;
            if (angular.isNumber(index)) {
                timeZone.id = index;
                timeZone.order = [parseInt(momentTz.format('Z')), momentTz.format('zz'), city];
            }

            return timeZone;
        }

        function formatDisplayValue(city, momentTz, format, isMomentNames) {

            const formatMap = {
                'tz-code': $translate.instant(`I18N.TIMEZONE_LOCATIONS.CODES.${momentTz.format('zz')}`),
                'offset-hours': momentTz.format('Z'),
                'location': $translate.instant(`I18N.TIMEZONE_LOCATIONS.${isMomentNames ? 'MOMENT' : 'CUSTOM'}.${city}`)
            };

            if (!format) return `(GMT ${formatMap['offset-hours']}) ${formatMap.location}`;

            for (let formatKey in formatMap) {
                format = format.replace(formatKey, formatMap[formatKey]);
            }

            return format;
        }

    }

})();
