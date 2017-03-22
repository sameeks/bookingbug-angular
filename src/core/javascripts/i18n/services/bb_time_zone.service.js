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

    function bbTimeZoneService($localStorage, bbi18nOptions, CompanyStoreService) {

        let displayTimeZone = null;
        let customTimeZone = false;

        return {
            determineTimeZone: determineTimeZone,
            getTimeZoneLs: getTimeZoneLs,
            getDisplayTimeZone: getDisplayTimeZone,
            isCustomTimeZone: isCustomTimeZone,
            updateTimeZone: updateTimeZone
        };

        function getTimeZoneLs() {
            return $localStorage.getItem('bbTimeZone');
        }

        function getDisplayTimeZone() {
            return displayTimeZone;
        }

        function isCustomTimeZone() {
            return customTimeZone;
        }

        function determineTimeZone() {

            if (getTimeZoneLs()) {
                updateTimeZone(getTimeZoneLs());
                return;
            }

            if (bbi18nOptions.use_browser_time_zone) {
                updateTimeZone(moment.tz.guess());
                return;
            }

            if (CompanyStoreService.time_zone) {
                updateTimeZone(CompanyStoreService.time_zone);
                return;
            }
        }

        function updateTimeZone(timeZone, updateLocalStorage) {

            moment.tz.setDefault(timeZone);
            displayTimeZone = timeZone;
            customTimeZone = timeZone !== CompanyStoreService.time_zone;

            if (updateLocalStorage) {
                updateLs(timeZone, customTimeZone);
            }

        }

        function updateLs(timeZone, customTimeZone) {
            if (customTimeZone) {
                $localStorage.setItem('bbTimeZone', timeZone);
            } else {
                $localStorage.removeItem('bbTimeZone');
            }
        }
    }

})();
