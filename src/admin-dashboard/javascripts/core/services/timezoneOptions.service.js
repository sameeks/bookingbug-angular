(function() {

    'use strict';

    /*
    * @ngdoc service
    * @name BBAdminDashboard.TimezoneOptions
    * @description
    * Factory for retrieving a list of timezones
    */
    angular
        .module('BBAdminDashboard')
        .factory('TimezoneOptions', timezoneOptionsFactory);

    function timezoneOptionsFactory ($translate, orderByFilter) {

        return {
            mapTimezoneForDisplay: mapTimezoneForDisplay,
            generateTimezoneList: generateTimezoneList
        };

        function cleanUpLocations () {
            var locationNames = moment.tz.names();
            locationNames = _.chain(locationNames)
                .filter(function (tz) {
                    return tz.indexOf('GMT') === -1;
                })
                .filter(function (tz) {
                    return tz.indexOf('Etc') === -1;
                })
                .filter(function (tz) {
                    return tz.match(/[^/]*$/)[0] !== tz.match(/[^/]*$/)[0].toUpperCase();
                })
                .value();
            return locationNames;
        }

        function mapTimezones (locationNames) {
            var timezones = [];
            locationNames.forEach(function (location, index) {
                timezones.push(mapTimezoneForDisplay(location, index));
            });
            timezones = _.uniq(timezones, function (timezone) {
                return timezone.display;
            });
            timezones = orderByFilter(timezones, ['order[0]', 'order[1]', 'order[2]'], false);
            return timezones;
        }

        function restrictToRegion (locationNames, restrictRegion) {

            function filterLocations (filterBy) {
                _.filter(locationNames, function (tz) {
                    return tz.indexOf(filterBy) !== -1;
                });
            }

            if (angular.isString(restrictRegion)) {
                locationNames = filterLocations(restrictRegion);
                return locationNames;
            }

            if (angular.isArray(restrictRegion)) {
                var locations = [];
                _.each(restrictRegion, function (region) {
                    locations.push(filterLocations(region));
                });
                locationNames = _.flatten(locations);
                return locationNames;
            }
        }

        /*
        * @ngdoc function
        * @name mapTzForDisplay
        * @methodOf BBAdminDashboard.Services:TimezoneOptions
        * @description Prepares a timezone string for display on FE
        * @param {String} Location
        * @param {Integer} Index
        * @returns {Object}
        */
        function mapTimezoneForDisplay (location, index) {
            var timezone = {};
            var city = location.match(/[^/]*$/)[0].replace(/-/g, '_').toUpperCase();
            var tz = moment.tz(location);
            timezone.display = '(UTC ' + tz.format("Z") + ') ' + $translate.instant("LOCATIONS." + city) + ' (' + tz.format("zz") + ')';
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
        * @methodOf BBAdminDashboard.Services:TimezoneOptions
        * @description Generates list of timezones for display on FE, removing duplicates and ordering by distance from UTC time
        * @param {String, Array} Restrict the timezones to one region (String) or multiple regions (Array)
        * @returns {Array} A list of timezones
        */
        function generateTimezoneList (restrictRegion) {
            var timezones = [];
            var locationNames = cleanUpLocations();
            if (restrictRegion) {
                locationNames = restrictToRegion(locationNames, restrictRegion);
            }
            timezones = mapTimezones(locationNames);
            return timezones;
        }
    }

})();
