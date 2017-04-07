(function () {

    /*
     * @ngdoc service
     * @name BBAdminDashboard.bbTimeZoneOptions
     * @description
     * TimeZone options factory
     */
    angular
        .module('BB.i18n')
        .service('bbTimeZone', bbTimeZoneService);

    function bbTimeZoneService(bbi18nOptions, CompanyStoreService, $localStorage, $log, $window, bbCustomTimeZones) {
        'ngInject';

        let displayTimeZone = bbi18nOptions.default_time_zone;

        return {
            convertToCompanyTz,
            convertToDisplayTz,
            determineTimeZone,
            getCompanyUTCOffset,
            getDisplayTimeZone,
            getDisplayUTCOffset,
            setDisplayTimeZone,
            getTimeZoneKey
        };

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @param {boolean} enforce
         * @returns {moment}
         */
        function convertToCompanyTz(dateTime, enforce = false) {
            return convertDateTime(dateTime, CompanyStoreService.time_zone, enforce);
        }

        /**
         * @param {moment|String} dateTime If string must be valid ISO string
         * @param {boolean} enforce
         * @returns {moment}
         */
        function convertToDisplayTz(dateTime, enforce = false) {
            return convertDateTime(dateTime, displayTimeZone, enforce);
        }

        function convertDateTime(dateTime, timeZone, enforce) {
            if (!moment(dateTime).isValid()) $log.error('not valid dateTime', dateTime);
            let converted = moment.tz(dateTime, timeZone);
            return converted;
        }

        function getDisplayTimeZone() {
            return displayTimeZone;
        }

        function determineTimeZone() {
            const timeZone = $localStorage.getObject('bbTimeZone').displayTimeZone;
            if (timeZone) {
                setDisplayTimeZone(timeZone);
                return;
            }

            if (bbi18nOptions.use_browser_time_zone) {
                setDisplayTimeZone(moment.tz.guess());
                return;
            }

            if (bbi18nOptions.use_company_time_zone && CompanyStoreService.time_zone) {
                setDisplayTimeZone(CompanyStoreService.time_zone);
            }
        }

        function getDisplayUTCOffset() {
            return moment().tz(displayTimeZone).utcOffset();
        }

        function getCompanyUTCOffset() {
            return moment().tz(CompanyStoreService.time_zone).utcOffset();
        }

        function setDisplayTimeZone(timeZone, isMomentNames = false, useBrowserTimeZone = false, updateLocalStorage = false) {
            if (bbCustomTimeZones.GROUPED_TIME_ZONES[timeZone] || isMomentNames) {
                moment.tz.setDefault(timeZone);
                displayTimeZone = timeZone;
            } else {
                timeZone = getTimeZoneKey(timeZone);
                moment.tz.setDefault(timeZone);
                displayTimeZone = timeZone;
            }
            if (updateLocalStorage) setLocalStorage(useBrowserTimeZone);
        }

        function getTimeZoneKey(timeZone) {
            let selectedTimeZone;

            const city = timeZone.match(/[^/]*$/)[0];
            for (let [groupName, groupCities] of Object.entries(bbCustomTimeZones.GROUPED_TIME_ZONES)) {
                groupCities = groupCities.split(/\s*,\s*/).map((tz) => tz.replace(/ /g, "_")).join(', ').split(/\s*,\s*/);
                const cityGroupIndex =  groupCities.findIndex((groupCity) => groupCity === city);
                if (cityGroupIndex !== -1){
                    selectedTimeZone = groupName;
                    break;
                }
            }

            return selectedTimeZone || $localStorage.getObject('bbTimeZone').displayTimeZone || CompanyStoreService.time_zone;
        }

        function setLocalStorage(useBrowserTimeZone) {

            $localStorage.setObject('bbTimeZone', { useBrowserTimeZone });

            if (!useBrowserTimeZone && (getCompanyUTCOffset() !== getDisplayUTCOffset())) {
                $localStorage.setObject('bbTimeZone', { useBrowserTimeZone, displayTimeZone });
            }
        }
    }

})();
