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

    function timeZoneOptionsService(bbi18nOptions, bbTimeZoneUtils) {
        'ngInject';

        const compose = (...funcs) => (value) => funcs.reduce((v, fn) => fn(v), value);
        const initOptions = (timeZones = [], displayFormat, timeZone) => {
            return {
                timeZone,
                timeZones,
                displayFormat,
                useCustomList: bbi18nOptions.timeZone.useCustomList,
                filters: bbi18nOptions.timeZone.filters,
                isDST: moment().isDST(),
            };
        };

        return {
            composeTimeZoneList,
            addMissingTimeZones
        };

        function composeTimeZoneList(displayFormat, timeZone) {
            const options = initOptions(undefined, displayFormat, timeZone);
            const composeTimeZones = compose(
                bbTimeZoneUtils.loadKeys,
                bbTimeZoneUtils.findFilterKeysInCustomList,
                bbTimeZoneUtils.filter,
                bbTimeZoneUtils.reject,
                bbTimeZoneUtils.filterDayLightOrStandard,
                bbTimeZoneUtils.ensureExists,
                bbTimeZoneUtils.mapModel,
                bbTimeZoneUtils.removeDuplicates,
                bbTimeZoneUtils.order
            );
            return composeTimeZones(options).timeZones;
        }

        function addMissingTimeZones(timeZones, displayFormat, timeZone) {
            const options = initOptions(timeZones, displayFormat, timeZone);
            const composeTimeZones = compose(
                bbTimeZoneUtils.ensureExists,
                bbTimeZoneUtils.mapModel,
                bbTimeZoneUtils.removeDuplicates,
                bbTimeZoneUtils.order
            );
            return options.filters.limitTo.length ? composeTimeZones(options).timeZones : timeZones;
        }
    }

})();
