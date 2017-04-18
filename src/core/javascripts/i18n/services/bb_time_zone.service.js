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
            getDisplayUTCOffset,
            getCompanyTimeZone,
            getCompanyUTCOffset,
            getTimeZoneKey,

            convertToCompanyTz,
            convertToDisplayTz,

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

        function getCompanyTimeZone() {
            return CompanyStoreService.time_zone;
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

            if (bbi18nOptions.timeZone.useBrowser || localStorage.useBrowserTimeZone) {
                let timeZone = getTimeZoneKey(moment.tz.guess(), bbi18nOptions.timeZone.useMomentNames);
                setDisplayTimeZone(timeZone);
                return;
            }

            if (bbi18nOptions.timeZone.useCompany && CompanyStoreService.time_zone) {
                let timeZone = getTimeZoneKey(CompanyStoreService.time_zone, bbi18nOptions.timeZone.useMomentNames);
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

        function getTimeZoneKey(timeZone, useMomentNames = false) {
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

    }

})();
