###**
* @ngdoc directive
* @name BB.Directives:bbTimeZone
* @restrict A
* @description
* Timezone name helper
* @param {String} time_zone_name The name of the time zone
* @param {Boolean} is_time_zone_diff Indicates if the users time zone is different to the company time zone
* @example
* <div bb-time-zone></div>
* @example_result
* <span bb-time-zone>All times are shown in British Summer Time.</span>
####
angular.module('BB.Directives').directive 'bbTimeZone', (GeneralOptions, CompanyStoreService) ->
  restrict: 'A'
  controllerAs: '$tzCtrl'
  templateUrl: '_time_zone_info.html'
  controller: () ->

    if GeneralOptions.custom_time_zone
      @is_time_zone_diff = true

    @time_zone_name = moment.tz(GeneralOptions.display_time_zone).format('zz')
