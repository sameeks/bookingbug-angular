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

    function timeZoneOptionsService($translate, $localStorage, moment, orderByFilter, bbCustomTimeZones, bbi18nOptions, CompanyStoreService, bbTimeZone) {
        'ngInject';

        const compose = (...funcs) => (value) => funcs.reduce((v, fn) => fn(v), value);

        const {
            useMomentNames,
            limitTimeZonesBy,
            excludeTimeZonesBy,
            daylightTimeZones,
            standardTimeZones
        } = bbi18nOptions.timeZone.options;

        let format;

        return {
            composeTimeZoneList,
            addBrowserTimeZone
        };

        function composeTimeZoneList(formatString) {

            format = formatString;

            const composeTimeZones = compose(
                filterTimeZones,
                rejectTimeZones,
                dayLightOrStandardTimeZones,
                checkCompanyTimeZone,
                checkDisplayTimeZone,
                mapTimeZonesModel,
                removeDuplicates,
                orderTimeZones
            );

            return composeTimeZones(loadTimeZoneList());

        }

        function addBrowserTimeZone(timeZones, formatString) {

            format = formatString;

            const composeTimeZones = compose(
                checkBrowserTimeZone,
                mapTimeZonesModel,
                removeDuplicates,
                orderTimeZones
            );

            return composeTimeZones(getTimeZoneNames());

            function getTimeZoneNames() {
                const timeZoneNames = [];
                for (let timeZone of timeZones) {
                    timeZoneNames.push(timeZone.value);
                }
                return timeZoneNames;
            }
        }

        function checkBrowserTimeZone(timeZones) {
            const timeZone = moment.tz.guess();
            if (timeZones.find((tz) => tz !== timeZone)) {
                timeZones.push(timeZone);
            }
            return timeZones;
        }

        function loadTimeZoneList() {
            return useMomentNames ? loadMomentNames() : Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES);
        }

        function loadMomentNames() {
            const timeZones = moment.tz.names();
            return _.chain(timeZones)
                .reject((tz) => tz.indexOf('GMT') !== -1)
                .reject((tz) => tz.indexOf('Etc') !== -1)
                .reject((tz) => tz.match(/[^/]*$/)[0] === tz.match(/[^/]*$/)[0].toUpperCase())
                .value();
        }

        function filterTimeZones(timeZones) {
            if (limitTimeZonesBy) return filterTimeZoneList(timeZones, limitTimeZonesBy);
            return timeZones;
        }

        function rejectTimeZones(timeZones) {
            if (excludeTimeZonesBy) return filterTimeZoneList(timeZones, excludeTimeZonesBy, true);
            return timeZones;
        }

        function dayLightOrStandardTimeZones(timeZones) {
            const isDayLightTime = moment().isDST();
            if (daylightTimeZones || standardTimeZones) return filterTimeZoneList(timeZones, isDayLightTime ? daylightTimeZones : standardTimeZones);
            return timeZones;
        }

        function checkCompanyTimeZone(timeZones) {
            if (timeZones.find((tz) => tz !== CompanyStoreService.time_zone)) {
                timeZones.push(CompanyStoreService.time_zone);
            }
            return timeZones;
        }

        function checkDisplayTimeZone(timeZones) {
            const timeZone = bbTimeZone.getDisplayTimeZone();
            if (timeZones.find((tz) => tz !== timeZone)) {
                timeZones.push(timeZone);
            }
            return timeZones;
        }

        function filterTimeZoneList(timeZones, timeZoneToFilter, exclude = false) {

            if (angular.isString(timeZoneToFilter)) {
                return filterOrReject(timeZoneToFilter);
            }

            if (angular.isArray(timeZoneToFilter)) {
                let locations = [];
                _.each(timeZoneToFilter, (region) => locations.push(filterOrReject(region)));
                return _.flatten(locations);
            }

            function filterOrReject(filterBy) {
                if (exclude) {
                    return _.reject(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                } else {
                    return _.filter(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
                }
            }
        }

        function mapTimeZonesModel(timeZoneNames) {
            const timeZones = [];
            for (let [index, timeZone] of timeZoneNames.entries()) {
                timeZones.push(mapTimeZoneItem(timeZone, index));
            }
            return timeZones;
        }

        function mapTimeZoneItem(timeZoneKey, index) {
            const city = timeZoneKey.match(/[^/]*$/)[0].replace(/-/g, '_');
            const momentTz = moment.tz(timeZoneKey);
            return {
                id: index,
                display: formatDisplayValue(city, momentTz, format),
                value: timeZoneKey,
                order: [parseInt(momentTz.format('Z')), momentTz.format('zz'), city]
            };
        }

        function formatDisplayValue(city, momentTz, format) {

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

        function removeDuplicates(timeZones) {
            return _.uniq(timeZones, (timeZone) => timeZone.display);
        }

        function orderTimeZones(timeZones) {
            return orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
        }

    }

})();
