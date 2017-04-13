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

        let displayTimeZone = bbi18nOptions.timeZone.default;

        return {
            getDisplayTimeZone,
            convertToCompanyTz,
            convertToDisplayTz,
            getCompanyUTCOffset,
            getDisplayUTCOffset,
            getTimeZoneKey,
            determineTimeZone,
            setDisplayTimeZone,
            setLocalStorage
        };

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @returns {moment}
         */
        function convertToCompanyTz(dateTime) {
            return convertDateTime(dateTime, CompanyStoreService.time_zone);
        }

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @returns {moment}
         */
        function convertToDisplayTz(dateTime) {
            return convertDateTime(dateTime, displayTimeZone);
        }

        function convertDateTime(dateTime, timeZone) {
            if (!moment(dateTime).isValid()) $log.error('not valid dateTime', dateTime);
            let converted = moment.tz(dateTime, timeZone);
            return converted;
        }

        function getDisplayTimeZone() {
            return displayTimeZone;
        }

        function getDisplayUTCOffset() {
            return moment().tz(displayTimeZone).utcOffset();
        }

        function getCompanyUTCOffset() {
            return moment().tz(CompanyStoreService.time_zone).utcOffset();
        }

        function determineTimeZone() {
            const localStorage = $localStorage.getObject('bbTimeZone');
            if (localStorage.displayTimeZone) {
                setDisplayTimeZone(localStorage.displayTimeZone);
                return;
            }

            if (bbi18nOptions.use_browser_time_zone || localStorage.useBrowserTimeZone) {
                let timeZone = getTimeZoneKey(moment.tz.guess());
                setDisplayTimeZone(timeZone);
                return;
            }

            if (bbi18nOptions.use_company_time_zone && CompanyStoreService.time_zone) {
                let timeZone = getTimeZoneKey(CompanyStoreService.time_zone);
                setDisplayTimeZone(timeZone);
            }
        }

        function setDisplayTimeZone(timeZone) {
            moment.tz.setDefault(timeZone);
            displayTimeZone = timeZone;
        }

        function setLocalStorage(localStorageObj) {
            $localStorage.setObject('bbTimeZone', localStorageObj);
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
