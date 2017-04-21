(function (angular) {

    angular.module('BBAdminDashboard.callCenter').config(callCenterTranslationsConfig);

    function callCenterTranslationsConfig($translateProvider) {
        'ngInject';

        let translations = {
            'ADMIN_DASHBOARD': {

                'SIDE_NAV': {
                    'CALL_CENTER_PAGE': {
                        'CALL_CENTER': 'Call center'
                    }
                },

                'CALL_CENTER_PAGE': {}
            }
        };

        $translateProvider.translations('en', translations);
    }

})(angular);
