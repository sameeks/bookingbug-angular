(function() {

    /*
    * @ngdoc service
    * @name BBAdminDashboard.bbTimeZoneOptions
    * @description
    * TimeZone options factory
    */
    angular
        .module('BB.i18n')
        .factory('bbTimeZoneOptions', timeZoneFactoryOptions);

    function timeZoneFactoryOptions ($translate, orderByFilter) {

        return {
            mapTimeZoneForDisplay: mapTimeZoneForDisplay,
            generateTimeZoneList: generateTimeZoneList
        };

        function cleanUpLocations () {
            let locationNames = moment.tz.names();
            locationNames = _.chain(locationNames)
                .filter((tz) => tz.indexOf('GMT') === -1)
                .filter((tz) => tz.indexOf('Etc') === -1)
                .filter((tz) => tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase())
                .value();
            return locationNames;
        }

        function mapTimeZones (locationNames, format, translate) {
            let timezones = [];
            for (let [index, value] of locationNames.entries()) {
                timezones.push(mapTimeZoneForDisplay(value, index, format, translate));
            }
            timezones = _.uniq(timezones, (timezone) => timezone.display);
            timezones = orderByFilter(timezones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timezones;
        }

        function restrictToRegion (locationNames, restrictRegion) {

            if (angular.isString(restrictRegion)) {
                return filterLocations(restrictRegion);
            }

            if (angular.isArray(restrictRegion)) {
                let locations = [];
                _.each(restrictRegion, (region) => locations.push(filterLocations(region)));
                return _.flatten(locations);
            }

            function filterLocations (filterBy) {
                return _.filter(locationNames, (tz) => tz.indexOf(filterBy) !== -1);
            }
        }

        function formatDisplayValue (format, translate = true, city, tz) {

            const translateMap = {
                tzCode: $translate.instant('COMMON.TIME_ZONE_CODES.' + tz.format('zz')),
                location: $translate.instant('COMMON.LOCATIONS.' + city),
            };

            const sampleFormat = {
                'utc-code': 'UTC',
                'tz-code': translate ? translateMap.tzCode : tz.format('zz'),
                'offset-hours': tz.format('Z'),
                'location': translate ? translateMap.location : city
            };

            if (format) {
                let display = format.replace(/'?\w[\w']*(?:-\w+)*'?/gi, (match) => sampleFormat[match] ? sampleFormat[match] : match);
                return display;
            }

            let display = `(UTC ${tz.format('Z')}) ${translate ? translateMap.location : city } (${translate ? translateMap.location : tz.format('zz')})`;
            return display;
        }

        /*
        * @ngdoc function
        * @name mapTzForDisplay
        * @methodOf BBAdminDashboard.Services:TimeZoneOptions
        * @description Prepares a timezone string for display on FE
        * @param {String} Location
        * @param {Integer} Index
        * @returns {Object}
        */
        function mapTimeZoneForDisplay (location, index, format, translate) {

            const timezone = {};
            const city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            const tz = moment.tz(location);
            timezone.display = formatDisplayValue(format, translate, city, tz);
            timezone.value = location;
            if (index) {
                timezone.id = index;
                timezone.order = [parseInt(tz.format('Z')), tz.format('zz'), city];
            }
            return timezone;
        }

        /*
        * @ngdoc function
        * @name generateTzList
        * @methodOf BBAdminDashboard.Services:TimeZoneOptions
        * @description Generates list of timezones for display on FE, removing duplicates and ordering by distance from UTC time
        * @param {String, Array} Restrict the timezones to one region (String) or multiple regions (Array)
        * @returns {Array} A list of timezones
        */
        function generateTimeZoneList (restrictRegion, format, translate) {

            let locationNames = cleanUpLocations();
            if (restrictRegion) {
                locationNames = restrictToRegion(locationNames, restrictRegion);
            }
            return mapTimeZones(locationNames, format, translate);
        }
    }

})();
