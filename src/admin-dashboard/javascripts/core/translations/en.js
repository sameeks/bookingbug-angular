(function () {

    /**
     * @ngdoc overview
     * @name BBAdminDashboard.translations
     * @description
     * Translations for the admin core module
     */
    angular
        .module('BBAdminDashboard')
        .config(translationsConfig);

    function translationsConfig ($translateProvider) {
        'ngInject';

        const translations = {
            SIDE_NAV_BOOKINGS: "BOOKINGS",
            SIDE_NAV_CONFIG: "CONFIGURATION",
            ADMIN_DASHBOARD: {
                CORE: {
                    GREETING: 'Hi',
                    LOGOUT: 'Logout',
                    VERSION: 'Version',
                    COPYRIGHT: 'Copyright',
                    SWITCH_TO_CLASSIC: 'Switch to Classic'
                }
            }
        };
        $translateProvider.translations('en', translations);
    }

})();
