angular.module('BB').run(function($bbug, DebugUtilsService, FormDataStoreService, $log, $rootScope, $sessionStorage, GeneralOptions) {
  'ngInject';

  $rootScope.$log = $log;
  $rootScope.$setIfUndefined = FormDataStoreService.setIfUndefined;

  if (!$rootScope.bb) { $rootScope.bb = {}; }
  $rootScope.bb.api_url = $sessionStorage.getItem("host");

  if ($bbug.support.opacity === false) {
    document.createElement('header');
    document.createElement('nav');
    document.createElement('section');
    document.createElement('footer');
  }

  if (GeneralOptions.use_local_time_zone) {
    GeneralOptions.display_time_zone = moment.tz.guess();
  }

});