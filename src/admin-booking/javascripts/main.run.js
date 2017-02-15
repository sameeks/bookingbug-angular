angular.module('BBAdminBooking').run(function ($rootScope, $log, DebugUtilsService, $bbug, $document,
                                               $sessionStorage, FormDataStoreService, AppConfig, BBModel) {
    'ngInject';

    BBModel.Admin.Login.$checkLogin().then(function () {
        if ($rootScope.user && $rootScope.user.company_id) {
            if (!$rootScope.bb) {
                $rootScope.bb = {};
            }
            return $rootScope.bb.company_id = $rootScope.user.company_id;
        }
    });

});
