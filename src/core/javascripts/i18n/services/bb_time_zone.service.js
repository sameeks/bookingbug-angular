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

    function bbTimeZoneService($localStorage, $log, moment, bbi18nOptions, CompanyStoreService, bbCustomTimeZones, bbTimeZoneUtils) {
        'ngInject';

        let displayTimeZone = bbTimeZoneUtils.getKeyInCustomList(bbi18nOptions.timeZone.default, bbi18nOptions.timeZone.useCustomList);

        return {
            getDisplay,
            getDisplayUTCOffset,
            getCompany,
            getCompanyUTCOffset,

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
            const { useBrowser, useCustomList, useCompany } = bbi18nOptions.timeZone;
            const localStorage = $localStorage.getObject('bbTimeZone');

            if (localStorage.displayTimeZone) {
                setDisplay(localStorage.displayTimeZone);
                return;
            }

            if (useBrowser || localStorage.useBrowserTimeZone) {
                let timeZone = bbTimeZoneUtils.getKeyInCustomList(moment.tz.guess(), useCustomList);
                setDisplay(timeZone);
                return;
            }

            if (useCompany && CompanyStoreService.time_zone) {
                let timeZone = bbTimeZoneUtils.getKeyInCustomList(CompanyStoreService.time_zone, useCustomList);
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

    }

})();
