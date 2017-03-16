(function() {

    /*
    * @ngdoc service
    * @name BBAdminDashboard.TimeZoneOptions
    * @description
    * Factory for retrieving a list of timezones
    */
    angular
        .module('BB.i18n')
        .factory('bbTimeZone', timeZoneFactory);

    function timeZoneFactory ($translate, $localStorage, orderByFilter, bbi18nOptions, GeneralOptions, CompanyStoreService) {

        return {
            getTimeZoneLs: getTimeZoneLs,
            determineTimeZone: determineTimeZone,
            updateDefaultTimeZone: updateDefaultTimeZone,
            mapTimeZoneForDisplay: mapTimeZoneForDisplay,
            generateTimeZoneList: generateTimeZoneList
        };

        function getTimeZoneLs () {
            return $localStorage.getItem('bbTimeZone');
        }

        function determineTimeZone () {

            if (getTimeZoneLs()) {
                updateDefaultTimeZone(getTimeZoneLs());
                return;
            }

            if (bbi18nOptions.use_browser_time_zone) {
                updateDefaultTimeZone(moment.tz.guess());
                return;
            }

            if (CompanyStoreService.time_zone) {
                updateDefaultTimeZone(CompanyStoreService.time_zone);
                return;
            }
        }

        function updateDefaultTimeZone (timeZone, localStorageAction) {
            if (localStorageAction === 'setItem') {
                $localStorage.setItem('bbTimeZone', timeZone);
            }

            if (localStorageAction === 'removeItem') {
                $localStorage.removeItem('bbTimeZone');
            }

            moment.tz.setDefault(timeZone);
            bbi18nOptions.display_time_zone = timeZone;
            GeneralOptions.custom_time_zone = timeZone !== CompanyStoreService.time_zone;
        }


        function cleanUpLocations () {
            let locationNames = moment.tz.names();
            locationNames = _.chain(locationNames)
                .filter((tz) => tz.indexOf('GMT') === -1)
                .filter((tz) => tz.indexOf('Etc') === -1)
                .filter((tz) => tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase())
                .value();
            return locationNames;
        }

        function mapTimeZones (locationNames) {
            let timezones = [];
            for (let [index, value] of locationNames.entries()) {
                timezones.push(mapTimeZoneForDisplay(value, index));
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
                _.filter(locationNames, (tz) => tz.indexOf(filterBy) !== -1);
            }
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
        function mapTimeZoneForDisplay (location, index) {
            const timezone = {};
            const city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            const tz = moment.tz(location);
            timezone.display = `(UTC ${tz.format('Z')}) ${$translate.instant('COMMON.LOCATIONS.' + city)} (${tz.format('zz')})`;
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
        function generateTimeZoneList (restrictRegion) {
            let timezones = [];
            let locationNames = cleanUpLocations();
            if (restrictRegion) {
                locationNames = restrictToRegion(locationNames, restrictRegion);
            }
            timezones = mapTimeZones(locationNames);
            return timezones;
        }
    }

})();
