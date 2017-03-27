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

    function bbTimeZoneService(bbi18nOptions, CompanyStoreService, $localStorage, $log, $window) {

        let displayTimeZone = bbi18nOptions.default_time_zone;

        return $window.tz = {
            convertToCompanyTz,
            convertToDisplayTz,
            determineTimeZone,
            getDisplayTimeZone,
            isCompanyTimeZone,
            setDisplayTimeZone
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

            if (!isCompanyTimeZone() && enforce === false) return dateTime; //TODO consider removing this line and make always conversion

            return moment.tz(dateTime, timeZone);
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

        function isCompanyTimeZone() {
            return displayTimeZone === CompanyStoreService.time_zone;
        }

        function setDisplayTimeZone(timeZone, shouldUpdateLocalStorage = false) {
            moment.tz.setDefault(timeZone);

            displayTimeZone = timeZone;

            if (shouldUpdateLocalStorage) updateLocalStorage(timeZone);
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
