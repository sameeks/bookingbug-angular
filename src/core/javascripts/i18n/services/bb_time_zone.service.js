(function() {

    /*
     * @ngdoc service
     * @name BBAdminDashboard.bbTimeZoneOptions
     * @description
     * TimeZone options factory
     */
    angular
        .module('BB.i18n')
        .service('bbTimeZone', bbTimeZoneService);

    function bbTimeZoneService ($localStorage, bbi18nOptions, GeneralOptions, CompanyStoreService) {

        return {
            getTimeZoneLs: getTimeZoneLs,
            determineTimeZone: determineTimeZone,
            updateDefaultTimeZone: updateDefaultTimeZone
        };

        function getTimeZoneLs () {
            return $localStorage.getItem('bbTimeZone');
        }

        function determineTimeZone () {

            if (getTimeZoneLs()) {
                updateDefaultTimeZone(getTimeZoneLs());
                return;
            }

            if (bbi18nOptions.use_browser_time_zone) {
                updateDefaultTimeZone(moment.tz.guess());
                return;
            }

            if (CompanyStoreService.time_zone) {
                updateDefaultTimeZone(CompanyStoreService.time_zone);
                return;
            }
        }

        function updateDefaultTimeZone (timeZone, localStorageAction) {
            if (localStorageAction === 'setItem') {
                $localStorage.setItem('bbTimeZone', timeZone);
            }

            if (localStorageAction === 'removeItem') {
                $localStorage.removeItem('bbTimeZone');
            }

            moment.tz.setDefault(timeZone);
            bbi18nOptions.display_time_zone = timeZone;
            GeneralOptions.custom_time_zone = timeZone !== CompanyStoreService.time_zone;
        }
    }

})();
