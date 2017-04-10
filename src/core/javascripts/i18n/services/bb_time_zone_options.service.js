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
            generateTimeZoneList,
            getTimeZoneKey
        };

        /**
         * @ngdoc function
         * @name generateTimeZoneList
         * @methodOf BBAdminDashboard.Services:TimeZoneOptions
         * @param {Boolean} useMomentNames
         * @param {String, Array} limitTimeZones - limit time zones to a specific region (String) or multiple regions (Array)
         * @param {String, Array} excludeTimeZones - exclude time zones from generated list
         * @param {String} format
         * @returns {Array} A list of time zones
         */
        function generateTimeZoneList(useMomentNames, limitTimeZones, excludeTimeZones, format) {
            let timeZones = [];

            let timeZoneNames = loadTimeZones(useMomentNames, limitTimeZones, excludeTimeZones);
            for (let [index, timeZone] of timeZoneNames.entries()) {
                timeZones.push(mapTimeZoneItem(timeZone, index, format, useMomentNames));
            }

            timeZones = _.uniq(timeZones, (timeZone) => timeZone.display);
            timeZones = orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timeZones;
        }

        function loadTimeZones(useMomentNames, limitTimeZones, excludeTimeZones) {
            let timeZoneNames = [];

            timeZoneNames = useMomentNames ? loadMomentNames() : Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES);
            if (limitTimeZones) timeZoneNames = filterTimeZoneList(timeZoneNames, limitTimeZones);
            if (excludeTimeZones) timeZoneNames = filterTimeZoneList(timeZoneNames, excludeTimeZones, true);

            return timeZoneNames;

            function loadMomentNames() {
                const timeZones = moment.tz.names();
                return _.chain(timeZones)
                    .reject((tz) => tz.indexOf('GMT') !== -1)
                    .reject((tz) => tz.indexOf('Etc') !== -1)
                    .reject((tz) => tz.match(/[^/]*$/)[0] === tz.match(/[^/]*$/)[0].toUpperCase())
                    .value();
            }
        }

        function filterTimeZoneList(timeZones, timeZoneToFilter, exclude = false) {

            if (angular.isString(timeZoneToFilter)) {
                return timeZoneFilter(timeZoneToFilter);
            }

            if (angular.isArray(timeZoneToFilter)) {
                let locations = [];
                _.each(timeZoneToFilter, (region) => locations.push(timeZoneFilter(region)));
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

        function mapTimeZoneItem(timeZoneKey, index, format, useMomentNames) {
            const city = timeZoneKey.match(/[^/]*$/)[0].replace(/-/g, '_');
            const momentTz = moment.tz(timeZoneKey);
            return {
                id: index,
                display: formatDisplayValue(city, momentTz, format, useMomentNames),
                value: timeZoneKey,
                order: [parseInt(momentTz.format('Z')), momentTz.format('zz'), city]
            };
        }

        function formatDisplayValue(city, momentTz, format, useMomentNames) {

            const formatMap = {
                'tz-code': $translate.instant(`I18N.TIMEZONE_LOCATIONS.CODES.${momentTz.format('zz')}`),
                'offset-hours': momentTz.format('Z'),
                'location': $translate.instant(`I18N.TIMEZONE_LOCATIONS.${useMomentNames ? 'MOMENT' : 'CUSTOM'}.${city.toUpperCase()}`)
            };

            if (!format) return `(GMT${formatMap['offset-hours']}) ${formatMap.location}`;

            for (let formatKey in formatMap) {
                format = format.replace(formatKey, formatMap[formatKey]);
            }

            return format;
        }

        function getTimeZoneKey(timeZone) {
            let selectedTimeZone;

            if (bbCustomTimeZones.GROUPED_TIME_ZONES[timeZone]) return timeZone;

            const city = timeZone.match(/[^/]*$/)[0];
            for (let [groupName, groupCities] of Object.entries(bbCustomTimeZones.GROUPED_TIME_ZONES)) {
                groupCities = groupCities.split(/\s*,\s*/).map((tz) => tz.replace(/ /g, "_")).join(', ').split(/\s*,\s*/);
                const cityGroupIndex = groupCities.findIndex((groupCity) => groupCity === city);
                if (cityGroupIndex !== -1){
                    selectedTimeZone = groupName;
                    break;
                }
            }

            return selectedTimeZone || timeZone;
        }
    }

})();
