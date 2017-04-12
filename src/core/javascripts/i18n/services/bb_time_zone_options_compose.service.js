// (function () {
//
//     /**
//      * @ngdoc service
//      * @name BBAdminDashboard.bbTimeZoneOptions
//      * @description
//      * TimeZone options factory
//      */
//     angular
//         .module('BB.i18n')
//         .factory('bbTimeZoneOptionsFunc', timeZoneOptionsService);
//
//     function timeZoneOptionsService (bbi18nOptions, $translate) {
//         'ngInject';
//
//         const { use_moment_names: useMomentNames,
//             limit_time_zones: limitTimeZonesBy,
//             exclude_time_zones: excludeTimeZonesBy,
//             daylight_time_zones: daylightTimeZones,
//             standard_time_zones: standardTimeZones } = bbi18nOptions;
//
//         const compose = (...funcs) => (value) => funcs.reduce((v, fn) => fn(v), value);
//
//         const loadTimeZoneList = () => {
//             return useMomentNames ? loadMomentNames() : Object.keys(bbCustomTimeZones.GROUPED_TIME_ZONES);
//         };
//
//         const loadMomentNames = () => {
//             const timeZones = moment.tz.names();
//             return _.chain(timeZones)
//                 .reject((tz) => tz.indexOf('GMT') !== -1)
//                 .reject((tz) => tz.indexOf('Etc') !== -1)
//                 .reject((tz) => tz.match(/[^/]*$/)[0] === tz.match(/[^/]*$/)[0].toUpperCase())
//                 .value();
//         };
//
//         const filterTimeZones = (timeZones) => {
//             if (limitTimeZonesBy) return filterTimeZoneList(timeZones, limitTimeZonesBy);
//             return timeZones;
//         };
//
//         const rejectTimeZones = (timeZones) => {
//             if (excludeTimeZonesBy) return filterTimeZoneList(timeZones, excludeTimeZonesBy, true);
//             return timeZones;
//         };
//
//         const dayLightOrStandardTimeZones = (timeZones) => {
//             if (daylightTimeZones || standardTimeZones) return filterDaylightOrStandard(timeZones, daylightTimeZones, standardTimeZones);
//             return timeZones;
//         };
//
//         const filterDaylightOrStandard = (timeZones, daylightTimeZones, standardTimeZones) => {
//             const isDayLightTime = moment().isDST();
//             const timeZoneNames = filterTimeZoneList(timeZones, isDayLightTime ? daylightTimeZones : standardTimeZones);
//             return timeZoneNames;
//         };
//
//         const checkLocalTimeZone = (timeZones) => {
//             const localTimeZone = moment.tz.guess();
//             if (!timeZones.find((tz) => tz === localTimeZone)) {
//                 timeZones.push(localTimeZone);
//             }
//             return timeZones;
//         };
//
//         const filterTimeZoneList = (timeZones, timeZoneToFilter, exclude = false) => {
//
//             if (angular.isString(timeZoneToFilter)) {
//                 return timeZoneFilter(timeZoneToFilter);
//             }
//
//             if (angular.isArray(timeZoneToFilter)) {
//                 let locations = [];
//                 _.each(timeZoneToFilter, (region) => locations.push(timeZoneFilter(region)));
//                 return _.flatten(locations);
//             }
//
//             function timeZoneFilter(filterBy) {
//                 if (exclude) {
//                     return _.reject(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
//                 } else {
//                     return _.filter(timeZones, (tz) => tz.indexOf(filterBy) !== -1);
//                 }
//             }
//         };
//
//         const mapTimeZonesModal = (timeZoneNames) => {
//             const timeZones = [];
//             for (let [index, timeZone] of timeZoneNames.entries()) {
//                 timeZones.push(mapTimeZoneItem(timeZone, index));
//             }
//             return timeZones;
//         };
//
//         const mapTimeZoneItem = (timeZoneKey, index) => {
//             let format = '(GMT tz-code) location';
//             const city = timeZoneKey.match(/[^/]*$/)[0].replace(/-/g, '_');
//             const momentTz = moment.tz(timeZoneKey);
//             return {
//                 id: index,
//                 display: formatDisplayValue(city, momentTz, format),
//                 value: timeZoneKey,
//                 order: [parseInt(momentTz.format('Z')), momentTz.format('zz'), city]
//             };
//         };
//
//         const formatDisplayValue = (city, momentTz, format) => {
//
//             const formatMap = {
//                 'tz-code': $translate.instant(`I18N.TIMEZONE_LOCATIONS.CODES.${momentTz.format('zz')}`),
//                 'offset-hours': momentTz.format('Z'),
//                 'location': $translate.instant(`I18N.TIMEZONE_LOCATIONS.${useMomentNames ? 'MOMENT' : 'CUSTOM'}.${city.toUpperCase()}`)
//             };
//
//             if (!format) return `(GMT${formatMap['offset-hours']}) ${formatMap.location}`;
//
//             for (let formatKey in formatMap) {
//                 format = format.replace(formatKey, formatMap[formatKey]);
//             }
//
//             return format;
//         };
//
//         const composeTimeZoneList = compose(
//             filterTimeZones,
//             rejectTimeZones,
//             dayLightOrStandardTimeZones,
//             checkLocalTimeZone,
//             mapTimeZonesModal
//         );
//
//         const listOfTimeZones = composeTimeZoneList(loadTimeZoneList());
//
//         console.log(listOfTimeZones);
//
//         // return listOfTimeZones;
//
//     }
//
// })();
