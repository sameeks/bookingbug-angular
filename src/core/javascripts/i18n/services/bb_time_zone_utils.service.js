(function () {

    /**
     * @ngdoc service
     * @name BBAdminDashboard.bbTimeZoneOptions
     * @description
     * TimeZone options factory
     */
    angular
        .module('BB.i18n')
        .factory('bbTimeZoneUtils', bbTimeZoneUtils);

    function bbTimeZoneUtils($translate, $log, moment, orderByFilter, bbi18nOptions, bbCustomTimeZones) {
        'ngInject';

        return {
            loadKeys,
            filter,
            reject,
            findFilterKeysInCustomList,
            filterDayLightOrStandard,
            ensureExists,
            mapModel,
            removeDuplicates,
            order,

            getKeyInCustomList,
            getEqualInList
        };

        function loadKeys(options) {
            return Object.assign({}, options, {
                timeZones: options.useCustomList ? Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES) : loadMomentNames()
            });
        }

        function loadMomentNames() {
            const timeZones = moment.tz.names();
            const contains = (timeZone) => (strings) => _.any(strings, (string) => timeZone.indexOf(string) !== -1);
            const isUpperCase = (timeZone) => timeZone.match(/[^/]*$/)[0] === timeZone.match(/[^/]*$/)[0].toUpperCase();
            return _.chain(timeZones)
                .reject(contains(['GMT', 'Etc']))
                .reject(isUpperCase)
                .value();
        }

        function findFilterKeysInCustomList(options) {
            const getKey = (timeZoneKey) => getKeyInCustomList(timeZoneKey, options.useCustomList);
            const mapFilters = (listOfFilters, typeOfFilter, filters) => filters[typeOfFilter] = _.map(listOfFilters, getKey);
            return Object.assign({}, options, {
                filters: _.mapObject(options.filters, mapFilters)
            });
        }

        function filter(options) {
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.filters.limitTo)
            });
        }

        function reject(options) {
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.filters.exclude, true)
            });
        }

        function filterDayLightOrStandard(options) {
            const { limitDaylightSaving, limitStandard } = options.filters;
            return Object.assign({}, options, {
                timeZones: filterTimeZoneList(options.timeZones, options.isDST ? limitDaylightSaving : limitStandard)
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

        function ensureExists(options) {
            return Object.assign({}, options, {
                timeZones: addMissingTimeZone(options.timeZones, options.timeZone)
            });
        }

        function addMissingTimeZone(timeZones, timeZone) {
            const mappedTimeZone = getEqualInList(timeZone, timeZones);
            const allTimeZones = [...timeZones];
            if (!allTimeZones.find((tz) => (tz.value || tz) === mappedTimeZone)) {
                allTimeZones.push(mappedTimeZone);
            }
            return allTimeZones;
        }

        function mapModel(options) {
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
                'location': $translate.instant(`I18N.TIMEZONE_LOCATIONS.${options.useCustomList ? 'CUSTOM' : 'MOMENT' }.${city.toUpperCase()}`)
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

        function order(options) {
            return Object.assign({}, options, {
                timeZones: orderByFilter(options.timeZones, ['order[0]', 'order[1]', 'order[2]'], false)
            });
        }

        function getKeyInCustomList(timeZone, useCustomList = true) {
            let selectedTimeZone;

            if (!useCustomList) return timeZone;
            if (bbCustomTimeZones.GROUPED_TIME_ZONES[timeZone]) return timeZone;

            const city = timeZone.match(/[^/]*$/)[0].replace(/ /g, "_");

            for (let [groupName, groupCities] of Object.entries(bbCustomTimeZones.GROUPED_TIME_ZONES)) {

                if (groupName.match(/[^/]*$/)[0] === city) {
                    selectedTimeZone = groupName;
                    break;
                }

                groupCities = groupCities.split(/\s*,\s*/).map((tz) => tz.replace(/ /g, "_")).join(', ').split(/\s*,\s*/);
                const cityGroupIndex = groupCities.findIndex((groupCity) => groupCity === city);
                if (cityGroupIndex !== -1){
                    selectedTimeZone = groupName;
                    break;
                }
            }

            return selectedTimeZone || timeZone;
        }

        function getEqualInList(timeZone, timeZones) {
            let selectedTimeZone;

            const overwrite = bbi18nOptions.timeZone.replaceBrowser;
            if (overwrite.replace && overwrite.replaceWith) {
                if (overwrite.replace === timeZone) {
                    selectedTimeZone = overwrite.replaceWith;
                    return selectedTimeZone;
                }
            }

            const formatTz = (timeZone, format) => moment.tz(timeZone).format(format);
            for (let tz of timeZones) {
                if (formatTz(tz.value || tz, 'zz') === formatTz(timeZone, 'zz') &&
                    formatTz(tz.value || tz, 'ZZ') === formatTz(timeZone, 'ZZ')) {
                    selectedTimeZone = tz.value || tz;
                    break;
                }
            }

            return selectedTimeZone || timeZone;
        }

    }

})();
