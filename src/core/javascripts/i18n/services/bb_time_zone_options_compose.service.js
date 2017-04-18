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

    function timeZoneOptionsService($translate, $log, moment, orderByFilter, bbCustomTimeZones, bbi18nOptions, bbTimeZone) {
        'ngInject';

        const compose = (...funcs) => (value) => funcs.reduce((v, fn) => fn(v), value);
        const initOptions = (timeZones = [], displayFormat) => {
            return {
                timeZones: timeZones,
                displayFormat: displayFormat,
                useMomentNames: bbi18nOptions.timeZone.useMomentNames,
                filters: bbi18nOptions.timeZone.filters,
                isDST: moment().isDST(),
            };
        };

        const fn = {
            loadTimeZoneKeys,
            filterTimeZones,
            rejectTimeZones,
            findFilterKeysInCustomList,
            filterDayLightOrStandardTimeZones,
            ensureDisplayTimeZoneExists,
            ensureBrowserTimeZoneExists,
            ensureCompanyTimeZoneExists,
            mapTimeZonesModel,
            removeDuplicates,
            orderTimeZones
        };

        return {
            composeTimeZoneList,
            addMissingTimeZones,
            fn
        };

        function composeTimeZoneList(displayFormat) {
            const options = initOptions(undefined, displayFormat);
            const composeTimeZones = compose(
                fn.loadTimeZoneKeys,
                fn.findFilterKeysInCustomList,
                fn.filterTimeZones,
                fn.rejectTimeZones,
                fn.filterDayLightOrStandardTimeZones,
                fn.ensureDisplayTimeZoneExists,
                fn.mapTimeZonesModel,
                fn.removeDuplicates,
                fn.orderTimeZones
            );

            return composeTimeZones(options).timeZones;

        }

        function addMissingTimeZones(timeZones, displayFormat) {
            const options = initOptions(timeZones, displayFormat);
            const composeTimeZones = compose(
                fn.ensureBrowserTimeZoneExists,
                fn.ensureCompanyTimeZoneExists,
                fn.mapTimeZonesModel,
                fn.removeDuplicates,
                fn.orderTimeZones
            );

            return composeTimeZones(options).timeZones;
        }

        function loadTimeZoneKeys(options) {
            return Object.assign({}, options, {
                timeZones: options.useMomentNames ? loadMomentNames() : Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES)
            });
        }

        function loadMomentNames() {
            const timeZones = moment.tz.names();
            const contains = (timeZone, string) => timeZone.indexOf(string) !== -1;
            const isUpperCase = (timeZone) => timeZone.match(/[^/]*$/)[0] === timeZone.match(/[^/]*$/)[0].toUpperCase();
            return _.chain(timeZones)
                .reject((timeZone) => contains(timeZone, 'GMT'))
                .reject((timeZone) => contains(timeZone, 'Etc'))
                .reject(isUpperCase)
                .value();
        }

        function ensureBrowserTimeZoneExists(options) {
            const browserTimeZone = bbTimeZone.getTimeZoneKey(moment.tz.guess(), options.useMomentNames);
            return Object.assign({}, options, {
                timeZones: ensureTimeZoneExists(options.timeZones, browserTimeZone)
            });
        }

        function ensureCompanyTimeZoneExists(options) {
            const companyTimeZone = bbTimeZone.getTimeZoneKey(bbTimeZone.getCompanyTimeZone(), options.useMomentNames);
            return Object.assign({}, options, {
                timeZones: ensureTimeZoneExists(options.timeZones, companyTimeZone)
            });
        }

        function ensureDisplayTimeZoneExists(options) {
            const displayTimeZone = bbTimeZone.getTimeZoneKey(bbTimeZone.getDisplayTimeZone(), options.useMomentNames);
            return Object.assign({}, options, {
                timeZones: ensureTimeZoneExists(options.timeZones, displayTimeZone)
            });
        }

        function ensureTimeZoneExists(timeZones, timeZone) {
            const allTimeZones = [...timeZones];
            if (!allTimeZones.find((tz) => (tz.value || tz) === timeZone)) {
                allTimeZones.push(timeZone);
            }
            return allTimeZones;
        }

        function findFilterKeysInCustomList(options) {
            const getKey = (timeZoneKey) => bbTimeZone.getTimeZoneKey(timeZoneKey, options.useMomentNames);
            const mapFilters = (listOfFilters, typeOfFilter, filters) => filters[typeOfFilter] = _.map(listOfFilters, getKey);
            return Object.assign({}, options, {
                filters: _.mapObject(options.filters, mapFilters)
            });
        }

        function filterTimeZones(options) {
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.filters.limitTimeZonesBy)
            });
        }

        function rejectTimeZones(options) {
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.filters.excludeTimeZonesBy, true)
            });
        }

        function filterDayLightOrStandardTimeZones(options) {
            const { daylightTimeZones, standardTimeZones } = options.filters;
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.isDST ? daylightTimeZones : standardTimeZones)
            });
        }

        function filterTimeZoneList(timeZones, timeZonesToFilter, exclude = false) {

            if (!angular.isArray(timeZonesToFilter)) {
                $log.error('must be an Array:', `${timeZonesToFilter}:${typeof(timeZonesToFilter)}`);
                return timeZones;
            }

            if (!timeZonesToFilter.length) {
                return timeZones;
            }

            const contains = (filters) => (timeZone) => _.any(filters, (filter) => timeZone.indexOf(filter) !== -1);
            if (exclude) {
                return _.reject(timeZones, contains(timeZonesToFilter));
            } else {
                return _.filter(timeZones, contains(timeZonesToFilter));
            }

        }

        function mapTimeZonesModel(options) {
            const mapTimeZone = (timeZone, index) => timeZone.value ? timeZone : mapTimeZoneItem(options, timeZone, index);
            return Object.assign({}, options, {
                timeZones: _.map(options.timeZones, mapTimeZone)
            });
        }

        function mapTimeZoneItem(options, timeZoneKey, index) {
            const city = timeZoneKey.match(/[^/]*$/)[0].replace(/-/g, '_');
            const momentTz = moment.tz(timeZoneKey);
            return {
                id: index,
                display: formatDisplayValue(options, city, momentTz),
                value: timeZoneKey,
                order: [parseInt(momentTz.format('Z')), momentTz.format('zz'), city]
            };
        }

        function formatDisplayValue(options, city, momentTz) {

            let format = angular.copy(options.displayFormat);

            const formatMap = {
                'tz-code': $translate.instant(`I18N.TIMEZONE_LOCATIONS.CODES.${momentTz.format('zz')}`),
                'offset-hours': momentTz.format('Z'),
                'location': $translate.instant(`I18N.TIMEZONE_LOCATIONS.${options.useMomentNames ? 'MOMENT' : 'CUSTOM'}.${city.toUpperCase()}`)
            };

            if (!format) return `(GMT${formatMap['offset-hours']}) ${formatMap.location}`;
            for (let formatKey in formatMap) {
                format = format.replace(formatKey, formatMap[formatKey]);
            }

            return format;
        }

        function removeDuplicates(options) {
            return Object.assign({}, options, {
                timeZones: _.uniq(options.timeZones, (timeZone) => timeZone.display)
            });
        }

        function orderTimeZones(options) {
            return Object.assign({}, options, {
                timeZones: orderByFilter(options.timeZones, ['order[0]', 'order[1]', 'order[2]'], false)
            });
        }

    }

})();
