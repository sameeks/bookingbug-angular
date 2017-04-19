(function () {

    /*
     * @ngdoc service
     * @name BBAdminDashboard.bbTimeZone
     * @description
     * TimeZone factory
     */
    angular
        .module('BB.i18n')
        .service('bbTimeZone', bbTimeZoneService);

    function bbTimeZoneService($localStorage, $log, moment, bbi18nOptions, CompanyStoreService, bbCustomTimeZones) {
        'ngInject';

        let displayTimeZone = getKeyInCustomList(bbi18nOptions.timeZone.default, bbi18nOptions.timeZone.useMomentNames);

        return {
            getDisplay,
            getDisplayUTCOffset,
            getCompany,
            getCompanyUTCOffset,
            getKeyInCustomList,
            getActual,

            convertToCompany,
            convertToDisplay,

            determine,
            setDisplay,
            setLocalStorage
        };

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @returns {moment}
         */
        function convertToCompany(dateTime) {
            return convertDateTime(dateTime, CompanyStoreService.time_zone);
        }

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @returns {moment}
         */
        function convertToDisplay(dateTime) {
            return convertDateTime(dateTime, displayTimeZone);
        }

        function convertDateTime(dateTime, timeZone) {
            if (!moment(dateTime).isValid()) $log.error('not valid dateTime', dateTime);
            let converted = moment.tz(dateTime, timeZone);
            return converted;
        }

        function getDisplay() {
            return displayTimeZone;
        }

        function getDisplayUTCOffset() {
            return moment().tz(displayTimeZone).utcOffset();
        }

        function getCompany() {
            return CompanyStoreService.time_zone;
        }

        function getCompanyUTCOffset() {
            return moment().tz(CompanyStoreService.time_zone).utcOffset();
        }

        function determine() {
            const { useBrowser, useMomentNames, useCompany } = bbi18nOptions.timeZone;
            const localStorage = $localStorage.getObject('bbTimeZone');
            if (localStorage.displayTimeZone) {
                setDisplay(localStorage.displayTimeZone);
                return;
            }

            if (useBrowser || localStorage.useBrowserTimeZone) {
                let timeZone = getKeyInCustomList(moment.tz.guess(), useMomentNames);
                setDisplay(timeZone);
                return;
            }

            if (useCompany && CompanyStoreService.time_zone) {
                let timeZone = getKeyInCustomList(CompanyStoreService.time_zone, useMomentNames);
                setDisplay(timeZone);
            }
        }

        function setDisplay(timeZone) {
            moment.tz.setDefault(timeZone);
            displayTimeZone = timeZone;
        }

        function setLocalStorage(localStorageObj) {
            $localStorage.setObject('bbTimeZone', localStorageObj);
        }

        function getKeyInCustomList(timeZone, useMomentNames = false) {
            let selectedTimeZone;

            if (useMomentNames) return timeZone;
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

        function getActual(timeZone, timeZones) {
            let selectedTimeZone;

            const overWrite = bbi18nOptions.timeZone.overwriteBrowser;
            if (overWrite.browser && overWrite.replaceWith) {
                if (overWrite.browser === timeZone) {
                    selectedTimeZone = overWrite.replaceWith;
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
