angular.module('BB', [
    'ngStorage',
    'ngMessages',
    'ngSanitize',
    'ngFileUpload',
    'ngCookies',
    'ngAnimate',

    'angular-carousel',
    'angular-hal',
    'angular-data.DSCacheFactory',
    'angular.filter',
    'pascalprecht.translate',
    'schemaForm',
    'ui.bootstrap',
    'ui.grid',
    'ui.grid.pagination',
    'ui.map',
    'ui.router.util',
    'ui.select',
    'ui-rangeSlider',
    'uiGmapgoogle-maps',
    'vcRecaptcha',

    'BB.Controllers',
    'BB.Filters',
    'BB.Models',
    'BB.Services',
    'BB.Directives',

    'BB.i18n',
    'BB.uib'
]);

angular.module('BB.Services', [
    'ngResource',
    'ngSanitize',
    'pascalprecht.translate'
]);

angular.module('BB.Controllers', [
    'ngSanitize'
]);

angular.module('BB.Directives', []);
angular.module('BB.Filters', []);
angular.module('BB.Models', []);
