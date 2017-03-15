angular.module('BB').run(function ($bbug, DebugUtilsService, FormDataStoreService, $log, $rootScope, $localStorage, $sessionStorage, GeneralOptions, CompanyStoreService, bbi18nOptions, bbTimeZone) {
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

    if (bbi18nOptions.use_browser_time_zone) {
        bbTimeZone.updateDisplayTimeZone(moment.tz.guess());
    }

    if ($localStorage.getItem('selectedTimeZone')) {
        bbTimeZone.updateDisplayTimeZone(localStorage.getItem('selectedTimeZone'));
    }

    if (bbTimeZone.displayTimeZone && bbTimeZone.displayTimeZone !== CompanyStoreService.time_zone) {
        GeneralOptions.custom_time_zone = true;
    }

});
