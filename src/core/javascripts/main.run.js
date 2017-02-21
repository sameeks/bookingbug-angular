angular.module('BB').run(function ($bbug, DebugUtilsService, FormDataStoreService, $log, $rootScope, $localStorage, $sessionStorage, GeneralOptions, CompanyStoreService) {
    'ngInject';

    $rootScope.$log = $log;
    $rootScope.$setIfUndefined = FormDataStoreService.setIfUndefined;

    if (!$rootScope.bb) {
        $rootScope.bb = {};
    }
    $rootScope.bb.api_url = $sessionStorage.getItem('host');

    if ($bbug.support.opacity === false) {
        document.createElement('header');
        document.createElement('nav');
        document.createElement('section');
        document.createElement('footer');
    }

    if (GeneralOptions.set_time_zone_automatically) {
        GeneralOptions.display_time_zone = moment.tz.guess();
    }

    if ($localStorage.getItem('selectedTimezone')) {
        GeneralOptions.display_time_zone = localStorage.getItem('selectedTimezone');
    }

    if (GeneralOptions.display_time_zone && GeneralOptions.display_time_zone !== CompanyStoreService.time_zone) {
        GeneralOptions.custom_time_zone = true;
    }

});
