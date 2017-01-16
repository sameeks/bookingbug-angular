'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbTimeZone
* @restrict A
* @description
* Timezone name helper
* @param {String} time_zone_name The name of the time zone
* @param {Boolean} is_time_zone_diff Indicates if the users time zone is different to the company time zone
* @example
* <span bb-time-zone ng-show="is_time_zone_diff">All times are shown in {{time_zone_name}}.</span>
* @example_result
* <span bb-time-zone ng-show="is_time_zone_diff">All times are shown in British Summer Time.</span>
####
angular.module('BB.Directives').directive 'bbTimeZone', (GeneralOptions, CompanyStoreService) ->
  restrict: 'A'
  link: (scope, el, attrs) ->
    company_time_zone = CompanyStoreService.time_zone
    scope.time_zone_name = moment().tz(company_time_zone).format('zz')
    #  if not using local time zone and user time zone is not same as companies
    if !GeneralOptions.use_local_time_zone and GeneralOptions.display_time_zone != company_time_zone
      scope.is_time_zone_diff = true
