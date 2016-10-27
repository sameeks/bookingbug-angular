'use strict'

angular.module('BB', [
  'angular-carousel'
  'ngStorage',
  'angular-hal',
  'ui.bootstrap',
  'ngSanitize',
  'ui.map',
  'ui.router.util',
  'ngAnimate',
  'angular-data.DSCacheFactory', # newer version of jmdobry angular cache'
  'ngFileUpload',
  'schemaForm',
  'uiGmapgoogle-maps',
  'angular.filter',
  'ui-rangeSlider',
  'ngCookies',
  'pascalprecht.translate',
  'vcRecaptcha',
  'ui.select',

  'BB.Controllers',
  'BB.Filters',
  'BB.Models',
  'BB.Services',
  'BB.Directives',

  'BB.i18n'
  'BB.uib'

])

angular.module('BB.Services', [
  'ngResource'
  'ngSanitize'
  'pascalprecht.translate'
])

angular.module('BB.Controllers', [
  'ngSanitize'
])

angular.module('BB.Directives', [])
angular.module('BB.Filters', [])
angular.module('BB.Models', [])