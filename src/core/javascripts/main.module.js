angular.module('BB', [
    'ngStorage',
    'ngMessages',
    'ngSanitize',
    'ngFileUpload',
    'ngCookies',
    'ngAnimate',
    'angularMoment',
    'angular-carousel',
    'angular-hal',
    'angular-data.DSCacheFactory',
    'angular.filter',
    'pascalprecht.translate',
    'schemaForm',
    'ui.bootstrap',
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

    'BB.analytics',
    'BB.i18n',
    'BB.uib',
    'BB.uiSelect'
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
