angular.module('BB').run(function ($bbug, FormDataStoreService, $log, $rootScope, $sessionStorage) {
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

});
