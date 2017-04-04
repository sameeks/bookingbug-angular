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

        function loadTimeZones (momentNames) {
            let locationNames = [];

            if (momentNames) {
                locationNames = moment.tz.names();
                locationNames = _.chain(locationNames)
                    .filter((tz) => tz.indexOf('GMT') === -1)
                    .filter((tz) => tz.indexOf('Etc') === -1)
                    .filter((tz) => tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase())
                    .value();
                return locationNames;
            }

            if (!momentNames) {
                locationNames = ['Etc/GMT+12',
                    'Pacific/Pago_Pago',
                    'Pacific/Honolulu',
                    'US/Alaska',
                    'America/Los_Angeles',
                    'America/Denver',
                    'America/Chihuahua',
                    'America/Phoenix',
                    'America/Chicago',
                    'Canada/Saskatchewan',
                    'America/Mexico_City',
                    'America/El_Salvador',
                    'America/New_York',
                    'America/Indiana/Knox',
                    'America/Bogota',
                    'America/Halifax',
                    'America/Caracas',
                    'America/Santiago',
                    'Canada/Newfoundland',
                    'America/Sao_Paulo',
                    'America/Buenos_Aires',
                    'America/Thule',
                    'Atlantic/Azores',
                    'Atlantic/Cape_Verde',
                    'Europe/London',
                    'Africa/Casablanca',
                    'Europe/Belgrade',
                    'Europe/Sarajevo',
                    'Europe/Paris',
                    'Europe/Amsterdam',
                    'Africa/Lagos',
                    'Europe/Bucharest',
                    'Africa/Cairo',
                    'Europe/Helsinki',
                    'Europe/Athens',
                    'Asia/Jerusalem',
                    'Africa/Harare',
                    'Europe/Istanbul',
                    'Europe/Moscow',
                    'Asia/Kuwait',
                    'Africa/Nairobi',
                    'Asia/Baghdad',
                    'Asia/Tehran',
                    'Asia/Dubai',
                    'Asia/Yerevan',
                    'Asia/Kabul',
                    'Asia/Yekaterinburg',
                    'Asia/Karachi',
                    'Asia/Kolkata',
                    'Asia/Kathmandu',
                    'Asia/Dhaka',
                    'Asia/Colombo',
                    'Asia/Almaty',
                    'Asia/Rangoon',
                    'Asia/Bangkok',
                    'Asia/Krasnoyarsk',
                    'Asia/Hong_Kong',
                    'Asia/Singapore',
                    'Asia/Taipei',
                    'Australia/Perth',
                    'Asia/Irkutsk',
                    'Asia/Seoul',
                    'Asia/Tokyo',
                    'Asia/Yakutsk',
                    'Australia/Darwin',
                    'Australia/Adelaide',
                    'Australia/Canberra',
                    'Australia/Brisbane',
                    'Australia/Tasmania',
                    'Asia/Vladivostok',
                    'Pacific/Guam',
                    'Asia/Magadan',
                    'Pacific/Fiji',
                    'Pacific/Auckland',
                    'Pacific/Tongatapu'];
                return locationNames;
            }
        }

        function updateTimeZoneNames (timeZones, timeZone, exclude) {

            if (angular.isString(timeZone)) {
                return timeZoneFilter(timeZone);
            }

            if (angular.isArray(timeZone)) {
                let locations = [];
                _.each(timeZone, (region) => locations.push(timeZoneFilter(region)));
                return _.flatten(locations);
            }

            return timeZones;

            function timeZoneFilter (filterBy) {
                if (exclude) {
                    return _.reject(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                } else {
                    return _.filter(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                }
            }
        }

        function formatDisplayValue (format, city, momentTz) {
            let display = '';

            const formatMap = {
                'tz-code': $translate.instant(`COMMON.TIME_ZONE_CODES.${momentTz.format('zz')}`),
                'offset-hours': momentTz.format('Z'),
                'location': $translate.instant(`COMMON.LOCATIONS.${city}`)
            };

            if (format && angular.isString(format)) {
                display = format.replace(/'?\w[\w']*(?:-\w+)*'?/gi, (match) => formatMap[match] ? formatMap[match] : match);
                return display;
            }

            display = `(GMT${formatMap['offset-hours']}) ${formatMap['location']}`;
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
        function mapTimeZoneItem (location, index, format) {
            const timeZone = {};
            const city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            const momentTz = moment.tz(location);
            timeZone.display = formatDisplayValue(format, city, momentTz);
            timeZone.value = location;
            if (angular.isNumber(index)) {
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
        function generateTimeZoneList (momentNames, limitTo, exclude, format) {
            let timeZones = [];

            let timeZoneNames = loadTimeZones(momentNames);

            if (limitTo) {
                timeZoneNames = updateTimeZoneNames(timeZoneNames, limitTo);
            }

            if (exclude) {
                timeZoneNames = updateTimeZoneNames(timeZoneNames, exclude, true);
            }

            for (let [index, value] of timeZoneNames.entries()) {
                timeZones.push(mapTimeZoneItem(value, index, format));
            }

            timeZones = _.uniq(timeZones, (timeZone) => timeZone.display);
            timeZones = orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timeZones;
        }

    }

})();
