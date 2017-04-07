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

        return $window.tz = {
            convertToCompanyTz,
            convertToDisplayTz,
            determineTimeZone,
            getCompanyUTCOffset,
            getDisplayTimeZone,
            getDisplayUTCOffset,
            isCompanyTimeZone,
            setDisplayTimeZone,
            findTimeZoneKey
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
            const lsTimeZone = $localStorage.getItem('bbTimeZone');
            if (lsTimeZone) {
                setDisplayTimeZone(lsTimeZone);
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

        function isCompanyTimeZone() {
            return displayTimeZone === CompanyStoreService.time_zone;
        }

        function setDisplayTimeZone(timeZone, isMomentNames = false, shouldUpdateLocalStorage = false) {
            if (bbCustomTimeZones.GROUPED_TIME_ZONES[timeZone] || isMomentNames) {
                moment.tz.setDefault(timeZone);
                displayTimeZone = timeZone;
                if (shouldUpdateLocalStorage) updateLocalStorage(timeZone);
            } else {
                timeZone = findTimeZoneKey(timeZone);
                moment.tz.setDefault(timeZone);
                displayTimeZone = timeZone;
            }
        }

        function findTimeZoneKey (timeZone) {
            let selectedTimeZone;

            const city = timeZone.match(/[^/]*$/)[0];
            for (let [key, value] of Object.entries(bbCustomTimeZones.GROUPED_TIME_ZONES)) {
                value = value.split(/\s*,\s*/).map((tz) => tz.replace(/ /g, "_")).join(', ').split(/\s*,\s*/);
                _.each(value, (tz) => tz === city ? selectedTimeZone = key : null);
            }

            return selectedTimeZone || CompanyStoreService.time_zone;
        }

        function updateLocalStorage(timeZone) {
            if (isCompanyTimeZone()) {
                $localStorage.removeItem('bbTimeZone');
            } else {
                $localStorage.setItem('bbTimeZone', timeZone);
            }
        }
    }

})();
