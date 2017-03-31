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
            mapTimeZoneItem: mapTimeZoneItem,
            generateTimeZoneList: generateTimeZoneList
        };

        function loadTimeZones () {
            let locationNames = moment.tz.names();
            locationNames = _.chain(locationNames)
                .filter((tz) => tz.indexOf('GMT') === -1)
                .filter((tz) => tz.indexOf('Etc') === -1)
                .filter((tz) => tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase())
                .value();
            return locationNames;
        }

        function restrictToRegion (timeZones, restrictRegion) {

            function filterTimeZones (filterBy) {
                return _.filter(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
            }

            if (angular.isString(restrictRegion)) {
                return filterTimeZones(restrictRegion);
            }

            if (angular.isArray(restrictRegion)) {
                let locations = [];
                _.each(restrictRegion, (region) => locations.push(filterTimeZones(region)));
                return _.flatten(locations);
            }

            return timeZones;
        }

        function formatDisplayValue ({translate = true, format} = {}, city, momentTz) {
            let display;
            const formatMap = {
                'utc-code': 'UTC',
                'tz-code': translate ? $translate.instant(`COMMON.TIME_ZONE_CODES.${momentTz.format('zz')}`) : momentTz.format('zz'),
                'offset-hours': momentTz.format('Z'),
                'location': translate ? $translate.instant(`COMMON.LOCATIONS.${city}`) : city
            };

            if (format && angular.isString(format)) {
                display = format.replace(/'?\w[\w']*(?:-\w+)*'?/gi, (match) => formatMap[match] ? formatMap[match] : match);
                return display;
            }

            display = `(UTC ${momentTz.format('Z')}) ${formatMap['location']} (${formatMap['tz-code']})`;
            return display;
        }

        /*
        * @ngdoc function
        * @name mapTzForDisplay
        * @methodOf BBAdminDashboard.Services:TimeZoneOptions
        * @param {String} Location
        * @param {Integer} Index
        * @returns {Object} A time zone oject
        */
        function mapTimeZoneItem (location, index, options) {
            const timeZone = {};
            const city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            const momentTz = moment.tz(location);
            timeZone.display = formatDisplayValue(options, city, momentTz);
            timeZone.value = location;
            if (index) {
                timeZone.id = index;
                timeZone.order = [parseInt(momentTz.format('Z')), momentTz.format('zz'), city];
            }
            return timeZone;
        }

        /*
        * @ngdoc function
        * @name generateTzList
        * @methodOf BBAdminDashboard.Services:TimeZoneOptions
        * @param {String, Array} Restrict the time zones to one region (String) or multiple regions (Array)
        * @returns {Array} A list of time zones
        */
        function generateTimeZoneList (restrictRegion, options) {
            let timeZones = [];

            const timeZoneNames = restrictToRegion(loadTimeZones(), restrictRegion);
            for (let [index, value] of timeZoneNames.entries()) {
                timeZones.push(mapTimeZoneItem(value, index, options));
            }

            timeZones = _.uniq(timeZones, (timeZone) => timeZone.display);
            timeZones = orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timeZones;
        }

    }

})();
