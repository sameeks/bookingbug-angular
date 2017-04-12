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

    function timeZoneOptionsService ($translate, orderByFilter, bbCustomTimeZones, bbi18nOptions) {
        'ngInject';

        return {
            composeTimeZoneList,
            getTimeZoneKey
        };

        function composeTimeZoneList(formatString) {

            const compose = (...funcs) => (value) => funcs.reduce((v, fn) => fn(v), value);

            const { use_moment_names: useMomentNames,
                limit_time_zones: limitTimeZonesBy,
                exclude_time_zones: excludeTimeZonesBy,
                daylight_time_zones: daylightTimeZones,
                standard_time_zones: standardTimeZones } = bbi18nOptions;

            const loadTimeZoneList = () => {
                return useMomentNames ? loadMomentNames() : Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES);
            };

            const loadMomentNames = () => {
                const timeZones = moment.tz.names();
                return _.chain(timeZones)
                    .reject((tz) => tz.indexOf('GMT') !== -1)
                    .reject((tz) => tz.indexOf('Etc') !== -1)
                    .reject((tz) => tz.match(/[^/]*$/)[0] === tz.match(/[^/]*$/)[0].toUpperCase())
                    .value();
            };

            const filterTimeZones = (timeZones) => {
                if (limitTimeZonesBy) return filterTimeZoneList(timeZones, limitTimeZonesBy);
                return timeZones;
            };

            const rejectTimeZones = (timeZones) => {
                if (excludeTimeZonesBy) return filterTimeZoneList(timeZones, excludeTimeZonesBy, true);
                return timeZones;
            };

            const dayLightOrStandardTimeZones = (timeZones) => {
                if (daylightTimeZones || standardTimeZones) return filterDaylightOrStandard(timeZones, daylightTimeZones, standardTimeZones);
                return timeZones;
            };

            const filterDaylightOrStandard = (timeZones, daylightTimeZones, standardTimeZones) => {
                const isDayLightTime = moment().isDST();
                const timeZoneNames = filterTimeZoneList(timeZones, isDayLightTime ? daylightTimeZones : standardTimeZones);
                return timeZoneNames;
            };

            const checkLocalTimeZone = (timeZones) => {
                const localTimeZone = moment.tz.guess();
                if (timeZones.find((tz) => moment.tz(tz).utcOffset() !== moment.tz(localTimeZone).utcOffset())) {
                    timeZones.push(localTimeZone);
                }
                return timeZones;
            };

            const filterTimeZoneList = (timeZones, timeZoneToFilter, exclude = false) => {

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
            };

            const mapTimeZonesModel = (timeZoneNames) => {
                const timeZones = [];
                for (let [index, timeZone] of timeZoneNames.entries()) {
                    timeZones.push(mapTimeZoneItem(timeZone, index));
                }
                return timeZones;
            };

            const mapTimeZoneItem = (timeZoneKey, index) => {
                const format = formatString;
                const city = timeZoneKey.match(/[^/]*$/)[0].replace(/-/g, '_');
                const momentTz = moment.tz(timeZoneKey);
                return {
                    id: index,
                    display: formatDisplayValue(city, momentTz, format),
                    value: timeZoneKey,
                    order: [parseInt(momentTz.format('Z')), momentTz.format('zz'), city]
                };
            };

            const formatDisplayValue = (city, momentTz, format) => {

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
            };

            const removeDuplicates = (timeZones) => {
                return _.uniq(timeZones, (timeZone) => timeZone.display);
            };

            const orderTimeZones = (timeZones) => {
                return orderByFilter(timeZones, ['order[0]', 'order[1]', 'order[2]'], false);
            };

            const composeTimeZones = compose(
                filterTimeZones,
                rejectTimeZones,
                dayLightOrStandardTimeZones,
                checkLocalTimeZone,
                mapTimeZonesModel,
                removeDuplicates,
                orderTimeZones
            );

            return composeTimeZones(loadTimeZoneList());

        }

        function getTimeZoneKey(timeZone) {
            let selectedTimeZone;

            if (bbi18nOptions.use_moment_names) return timeZone;
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
